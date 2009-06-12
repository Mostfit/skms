class Groups < Application
  # provides :xml, :yaml, :js

  def index
    @groups = params[:user_id] ? Group.all('memberships.user_id' => params[:user_id]) : Group.all 
    display @groups
  end

  def show(id)
    @group = Group.get(id)
    raise NotFound unless @group
    display @grou
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

end # Groups
