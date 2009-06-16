class PollChoices < Application
  # provides :xml, :yaml, :js
  before :get_context
  before :ensure_is_poll_owner

  def get_context
    @poll = Poll.get(params[:poll_id])
    @is_owner = @poll.user == session.user
  end

  def ensure_is_poll_owner
    raise NotPrivileged unless @is_owner
  end

  def index
    @poll_choices = PollChoice.all(:poll => @poll)
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
    display [@poll,@poll_choice]
  end

  def edit(id)
    only_provides :html
    @poll_choice = PollChoice.get(id)
    raise NotFound unless @poll_choice
    display [@poll,@poll_choice]
  end

  def create(poll_choice)
    @poll_choice = PollChoice.new(poll_choice)
    @poll_choice.poll = @poll
    if @poll_choice.save
      redirect resource(@poll), :message => {:notice => "PollChoice was successfully created"}
    else
      message[:error] = "PollChoice failed to be created"
      render :new
    end
  end

  def update(id, poll_choice)
    @poll_choice = PollChoice.get(id)
    raise NotFound unless @poll_choice
    if @poll_choice.update_attributes(poll_choice)
       redirect resource(@poll)
    else
      display @poll_choice, :edit
    end
  end

  def delete(id)
    @poll_choice = PollChoice.get(id)
    if @poll_choice.votes.blank?
      edit(id)
    else
      redirect resource(@poll), :message => {:notice => 'Cannot delete poll choice which has votes' }
    end
  end

  def destroy(id)
    @poll_choice = PollChoice.get(id)
    raise NotFound unless @poll_choice
    if @poll_choice.votes.blank?
      if @poll_choice.destroy
        redirect resource(@poll), :message => {:notice => 'Poll choice destroyed' }
      else
        raise InternalServerError
      end
    else
      redirect resource(@poll), :message => {:notice => 'Cannot delete poll choice which has votes' }
    end
  end

end # PollChoices
