class Users < Application

  def index
    @user=session.user
    display @user
  end

  def show(id)
    @user = User.get(id)
    raise NotFound unless @user
    display @user
  end

  def update(id,user)
    @user = User.get(id)
    raise NotFound unless @user
    if @user.update_attributes(user)
       redirect url(:users), :message=>{:notice=>"image uploaded successfully"}
    else
      display @user, :edit
    end
  end

  def login
    # if the user is logged in, then redirect them to their profile
    redirect url(:tweets), :message => { :notice => 'You are now logged in' }
  end

end
