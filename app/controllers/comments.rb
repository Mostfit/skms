class Comments < Application
  # provides :xml, :yaml, :js

  def create(comment)
    @comment = Comment.new(comment)
    @comment.user = session.user
    @comment.tweet_id = params[:tweet]
    if @comment.save
      redirect url(:tweet,  @comment.tweet), :message => {:notice => "Comment was successfully created"}
    else
      message[:error] = "Comment failed to be created"
      redirect url(:tweet,  @comment.tweet)
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
