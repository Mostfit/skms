class Events < Application
  # provides :xml, :yaml, :js

  def index
    @events = Event.all
    display @events
  end

  def show(id)
    @event = Event.get(id)
    raise NotFound unless @event
    display @event
  end

  def new
    only_provides :html
    @event = Event.new
    display @event
  end

  def edit(id)
    only_provides :html
    @event = Event.get(id)
    raise NotFound unless @event
    display @event
  end

  def create(event)
    @event = Event.new(event)
    if @event.save
      redirect resource(@event), :message => {:notice => "Event was successfully created"}
    else
      message[:error] = "Event failed to be created"
      render :new
    end
  end

  def update(id, event)
    @event = Event.get(id)
    raise NotFound unless @event
    if @event.update_attributes(event)
       redirect resource(@event)
    else
      display @event, :edit
    end
  end

  def destroy(id)
    @event = Event.get(id)
    raise NotFound unless @event
    if @event.destroy
      redirect resource(:events)
    else
      raise InternalServerError
    end
  end

end # Events
