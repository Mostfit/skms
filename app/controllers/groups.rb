class Groups < Application
  provides :xml, :yaml, :js

  def index
    @groups = Group.all 
    display @groups
  end

  def show(id)
    @group = Group.get(id)
    raise NotFound unless @group
    display @group
  end

  def new
    only_provides :html
    @group = Group.new
    display @group
  end

  def edit(id)
    only_provides :html
    @group = Group.get(id)
    raise NotFound unless @group
    display @group
  end

  def create(group)
    @group = Group.new(group)
    if @group.save
      redirect resource(@group), :message => {:notice => "Group was successfully created"}
    else
      message[:error] = "Group failed to be created"
      render :new
    end
  end

  def update(id, group)
    @group = Group.get(id)
    raise NotFound unless @group
    if @group.update_attributes(group)
       redirect resource(@group)
    else
      display @group, :edit
    end
  end

  def destroy(id)
    @group = Group.get(id)
    raise NotFound unless @group
    if @group.destroy
      redirect resource(:groups)
    else
      raise InternalServerError
    end
  end

  def join(id, user_id)
    @group = Group.get(id)
    raise NotFound unless @group
    membership = Membership.new({:user_id => user_id, :group_id => id})
    membership.save
    redirect url(:groups)
  end

  def leave(id, user_id)
    membership = Membership.all(:user_id => user_id, :group_id => id)
    if membership.destroy!
      redirect url(:groups)
    else
      raise InternalServerError
    end
  end

  def approve(id, user_id)
    membership = Membership.all(:user_id => user_id, :group_id => id)
    raise NotPreveliged unless memberhip.can_be_approved_by(user_id) 
    memberhip.approved = true
  end

  def membership
    @groups = Group.all('memberships.user_id' => session.user.id) 
    display @groups
  end


end # Groups
