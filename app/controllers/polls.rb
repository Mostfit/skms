class Polls < Application
  # provides :xml, :yaml, :js

  def index
    @polls = Poll.all
    display @polls
  end

  def show(id)
    @poll = Poll.get(id)
    raise NotFound unless @poll
    display @poll
  end

  def new
    only_provides :html
    @poll = Poll.new
    display @poll
  end

  def edit(id)
    only_provides :html
    @poll = Poll.get(id)
    raise NotFound unless @poll
    display @poll
  end

  def create(poll)
    @poll = Poll.new(poll)
    if @poll.save
      redirect resource(@poll), :message => {:notice => "Poll was successfully created"}
    else
      message[:error] = "Poll failed to be created"
      render :new
    end
  end

  def update(id, poll)
    @poll = Poll.get(id)
    raise NotFound unless @poll
    if @poll.update_attributes(poll)
       redirect resource(@poll)
    else
      display @poll, :edit
    end
  end

  def destroy(id)
    @poll = Poll.get(id)
    raise NotFound unless @poll
    if @poll.destroy
      redirect resource(:polls)
    else
      raise InternalServerError
    end
  end

end # Polls
