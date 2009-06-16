class Polls < Application
  # provides :xml, :yaml, :js
  before :ensure_authenticated

  def index
    @polls = Poll.all(:closing_date.gt => Date.today, :published => true)
    display @polls
  end
  
  def my
    @polls = Poll.all(:user_id => session.user.id)
    display @polls, 'polls/index'
  end

  def closed
    @polls = Poll.all(:closing_date.lt => Date.today)
    display @polls, 'polls/index'
  end

  def open
    @polls = Poll.all(:closing_date.lte => Date.today)
    display @polls, 'polls/index'
  end

  def all
    @polls = Poll.all
    display @polls, 'polls/index'
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
    if @poll.published
      redirect resource(@poll), :message => { :notice => 'Poll cannot be changed once published' }
    end
    display @poll
  end

  def create(poll)
    @poll = Poll.new(poll)
    @poll.user = session.user
    if @poll.save
      add_event(session.user,"created a new poll:", @poll.topic, resource(@poll))
      redirect resource(@poll), :message => {:notice => "Poll was successfully created. Poll will not be visible until published"}
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

  def publish(id)
    @poll = Poll.get(id)
    raise NotFound unless @poll
    @poll.published = true
    @poll.save
    redirect resource(@poll), :message => {:notice => 'Poll succesfully published'}
  end

  def vote(id)
    @poll = Poll.get(id)
    message = ""
    previous_votes = Vote.all('poll_choice.poll_id' => @poll.id, :user_id => session.user.id)
    if previous_votes.size > 0
      old_vote = previous_votes[0]
      message = "Deleted old vote for choice #{old_vote.poll_choice.text}. "
      old_vote.destroy
    end
    @vote = Vote.new
    @vote.poll_choice_id = params[:vote]
    @vote.user_id = session.user.id
    @vote.save
    message = message + "Voted for #{@vote.poll_choice.text}"
    add_event(session.user,"voted for #{@vote.poll_choice.text} in the poll", @poll.topic, resource(@poll))
    redirect resource(@poll), :message => {:notice => message}
  end


end # Polls
