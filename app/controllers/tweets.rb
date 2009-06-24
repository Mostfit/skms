class Tweets < Application
  # provides :xml, :yaml, :js

  def index
    @tweets = Tweet.all :discriminator => [Tweet, Reply]
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
       redirect url(:edit_tweet, @tweet)
    else
      display @tweet, :edit
    end
  end

  def delete(id)
    debugger
    @tweet = Tweet.get(id)
    raise NotFound unless @tweet
    raise NotPrivileged unless (session.user.id == @tweet.can_delete?)
    if @tweet.destroy
      redirect resource(:tweets)
    else
      raise InternalServerError
    end
  end

  def tag(id, tweet)
    debugger
    @tweet = Tweet.get(id)
    raise NotFound unless @tweet
    tweet[:tag_list] = @tweet.tag_list.join(',') + ',' + tweet[:tag_list]
    if @tweet.update_attributes(tweet)
       redirect url(:edit_tweet, @tweet)
    else
      display @tweet, :edit
    end
  end

  def replies
    @replies = Reply.all :for_id => session.user.id
    display @replies
  end

  def private_messages
    @pms = PrivateMessage.all :for_id => session.user.id
    display @pms
  end


end # Tweets
