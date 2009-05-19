class Tweets < Application
  # provides :xml, :yaml, :js

  def index
    @tweets = Tweet.all
    display @tweets
  end

  def show(id)
    @tweet = Tweet.get(id)
    raise NotFound unless @tweet
    display @tweet
  end

  def new
    only_provides :html
    @tweet = Tweet.new
    display @tweet
  end

  def edit(id)
    only_provides :html
    @tweet = Tweet.get(id)
    raise NotFound unless @tweet
    display @tweet
  end

  def create()
    debugger
    @tweet = Tweet.new()
    @tweet.content=params[:tweet]
    @tweet.created=DateTime.now
    if @tweet.save
      redirect url(:tweets), :message => {:notice => "Tweet was successfully created"}
    else
      message[:error] = "Tweet failed to be created"
      render :new
    end
  end

  def update(id, tweet)
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
