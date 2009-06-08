class PollChoices < Application
  # provides :xml, :yaml, :js

  def index
    @poll_choices = PollChoice.all
    display @poll_choices
  end

  def show(id)
    @poll_choice = PollChoice.get(id)
    raise NotFound unless @poll_choice
    display @poll_choice
  end

  def new
    only_provides :html
    @poll_choice = PollChoice.new
    display @poll_choice
  end

  def edit(id)
    only_provides :html
    @poll_choice = PollChoice.get(id)
    raise NotFound unless @poll_choice
    display @poll_choice
  end

  def create(poll_choice)
    @poll_choice = PollChoice.new(poll_choice)
    if @poll_choice.save
      redirect resource(@poll_choice), :message => {:notice => "PollChoice was successfully created"}
    else
      message[:error] = "PollChoice failed to be created"
      render :new
    end
  end

  def update(id, poll_choice)
    @poll_choice = PollChoice.get(id)
    raise NotFound unless @poll_choice
    if @poll_choice.update_attributes(poll_choice)
       redirect resource(@poll_choice)
    else
      display @poll_choice, :edit
    end
  end

  def destroy(id)
    @poll_choice = PollChoice.get(id)
    raise NotFound unless @poll_choice
    if @poll_choice.destroy
      redirect resource(:poll_choices)
    else
      raise InternalServerError
    end
  end

end # PollChoices
