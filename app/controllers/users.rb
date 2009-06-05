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
    user=session.user
    if user.created_at==DateTime.now
      redirect url(:user,user.id), :message => { :notice => 'You are now logged in' }
    else
      redirect url(:tweets), :message => { :notice => 'You are now logged in' }
    end
  end

end
