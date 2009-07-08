class Tweets < Application
  provides :xml, :yaml, :js

  def index
    @tweets = Tweet.all(:protected => false).paginate(:per_page => 10, :page => params[:page]) #dm-pagination has been used
    display @tweets
  end

  #no 'new', as a new tweet is created from the home page itself

  #the individual page of each tweet is handeled by 'edit'.
  def edit(id)
    only_provides :html
    @tweet = Tweet.get(id)
    raise NotFound unless @tweet
    display @tweet
  end

  #creating a new tweet.
  def create(tweet)
    # create a new tweet
    @tweet = Tweet.new
    @tweet.made_by=session.user

    content = tweet[:content].strip #remove whitespace from front and back of the tweet's content

    # find out if the tweet is a private message or a group message or a reply
    is_pm = params[:for_users] || content.index('pm ') #from the form or command- 'dm yeban Holla!'
    is_gm = params[:for_group] || content.index('gm ') #from the form or command- 'gm Music Holla!'
    is_reply = content.index('@') #if the tweet contains '@', it is a reply

    if is_pm # if it is a private message

      # find the user it is intended for
      if params[:for_users] #from the form
        user = User.get params[:for_users].to_i
      else #from the command
        nick = content.split[1]
        user = User.all(:nick => nick)[0]
      end #finding user ends

      raise NotFound unless user # raise error if the user does not exist

      # if the user exists
      content = content.sub(/pm #{nick} /, '')
      @tweet.content = content
      @tweet.for_users << user #tweet has many to many relation with for_user
      @tweet.protected = true

    elsif is_gm # create a group message

      # find the group it is intended for
      if params[:for_group] #from the form
        group = Group.get params[:for_group].to_i
      else #from the command
        name = content.split[1]
        group = Group.all(:name => name)[0]
      end #finding user ends

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
      
      #find the users it is intended for
      users = []
      content.split.each do |word|
        if word.match(/\@\w+/) #if the word is like '@yeban'
          nick = word.match(/\w+/) #take yeban
          users << User.first(:nick => nick.to_s) #find the user
        end # if ends
      end # do ends

      @tweet.content = content
      @tweet.for_users = users

    else # a normal tweet
      @tweet.content = content
    end

    if @tweet.save
      redirect(url(:private_messages), :message => {:notice => "Private Message sent successfully."}) if is_pm
      redirect(url(:group_messages), :message => {:notice => "Group Message sent successfully."}) if is_gm
      redirect url(:tweets), :message => {:notice => "Tweet was successfully created."}
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
    @tweet = Tweet.get(id)
    raise NotFound unless @tweet
    raise NotPrivileged unless (session.user == @tweet.made_by)
    if @tweet.destroy
      redirect resource(:tweets)
    else
      raise InternalServerError
    end
  end

  def tag_custom(id, tweet)
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

  def private_messages #group or private messages
    @pms = session.user.private_messages
    display @pms
  end

  def group_messages
    @gms = session.user.group_messages
    display @gms
  end

end # Tweets
