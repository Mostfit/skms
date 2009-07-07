class Comments < Application
  # provides :xml, :yaml, :js

  def new
    only_provides :html
    @comment = Comment.new
    display @comment
  end

  def edit(id)
    only_provides :html
    @comment = Comment.get(id)
    raise NotFound unless @comment
    display @comment
  end

  def create(comment)
    @comment = Comment.new(comment)
    @comment.user = session.user
    @comment.tweet = Tweet.get params[:tweet]
    if @comment.save
      redirect url(:edit_tweet,  @comment.tweet), :message => {:notice => "Comment was successfully created"}
    else
      message[:error] = "Comment failed to be created"
      redirect url(:edit_tweet,  tweet)
    end
  end

  def update(id, comment)
    @comment = Comment.get(id)
    raise NotFound unless @comment
    if @comment.update_attributes(comment)
       redirect resource(@comment)
    else
      display @comment, :edit
    end
  end

  def destroy(id)
    @comment = Comment.get(id)
    raise NotFound unless @comment
    if @comment.destroy
      redirect resource(:comments)
    else
      raise InternalServerError
    end
  end

end # Comments
