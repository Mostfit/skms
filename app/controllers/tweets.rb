class Tweets < Application
  provides :xml, :yaml, :js

  def index
    @tweets = Tweet.all :protected => false
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

    # find out if the tweet is a private message or a group message or a reply
    content = tweet[:content].strip
    is_pm = params[:for_users] || content.index('pm ')
    is_gm = params[:for_group] || content.index('gm ')
    is_reply = content.index('@')

    if is_pm # if it is a private message
      # find the user it is intended for
      if params[:for_users]
        user = User.get params[:for_users].to_i
      else
        nick = content.split[1]
        user = User.all(:nick => nick)[0]
      end
        raise NotFound unless user # raise error if the user does not exist
        # if the user exists
        @tweet = Tweet.new
        content = content.sub(/pm #{nick} /, '')
        @tweet.content = content
        @tweet.made_by=session.user
        @tweet.for_users << user
        @tweet.protected = true
    elsif is_gm # create a group message
      # find the group it is intended for
      if params[:for_group] #create a group message
        group = Group.get params[:for_group].to_i
      else
        name = content.split[1]
        group = Group.all(:name => name)[0]
      end
        raise NotFound unless group # raise error if the group does not exist
        raise NotPriviliged unless session.user.is_member? group
        # if the group exists and the user is a member
        @tweet = Tweet.new
        content = content.sub(/gm #{name} /, '')
        @tweet.content = content
        @tweet.made_by=session.user
        @tweet.for_group = group
        @tweet.protected = true
    elsif is_reply # create a reply, it may be for more than one user
      users = []
      content.split.each do |word|
        if word.match(/\@\w+/)
          nick = word.match(/\w+/)
          users << User.first(:nick => nick.to_s)
        end # if ends
      end # do ends

      @tweet = Tweet.new
      @tweet.content = content
      @tweet.made_by=session.user
      @tweet.for_users = users

    else # a normal tweet
      @tweet = Tweet.new
      @tweet.content = content
      @tweet.made_by=session.user
    end

    if @tweet.save
      redirect url(:tweets), :message => {:notice => "Tweet was successfully created"}
    else
      message[:error] = "Tweet failed to be created"
      render :index
    end
  end

  def update(id,tweet)
    debugger
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
    @replies = session.user.replies
    display @replies
  end

  def messages #group or private messages
    @pms = session.user.private_messages
    @gms = session.user.group_messages
    display @pms
  end


end # Tweets
