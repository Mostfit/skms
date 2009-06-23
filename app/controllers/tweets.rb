class Tweets < Application
  # provides :xml, :yaml, :js

  def index
    @tweets = Tweet.all
    display @tweets
  end

  def edit(id)
    only_provides :html
    @tweet = Tweet.get(id)
    raise NotFound unless @tweet
    display @tweet
  end

  def create(tweet)
    debugger
    klass = tweet[:content].index("@#{session.user.nick}")? Kernel::const_get("Reply"): Kernel::const_get("Tweet")
    @tweet = klass.new(tweet)
    @tweet.made_by=session.user
    @tweet.discriminator=klass
    if @tweet.save
      redirect url(:tweets), :message => {:notice => "Tweet was successfully created"}
    else
      message[:error] = "Tweet failed to be created"
      render :index
    end
  end

  def update(id,tweet)
    @tweet = Tweet.get(id)
    raise NotFound unless @tweet
    if @tweet.update_attributes(tweet)
       redirect resource(@tweet)
    else
      display @tweet, :edit
    end
  end

  def destroy(id)
    @tweet = Tweet.get(id)
    raise NotFound unless @tweet
    if @tweet.destroy
      redirect resource(:tweets)
    else
      raise InternalServerError
    end
  end


end # Tweets
