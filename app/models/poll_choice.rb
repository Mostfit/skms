class PollChoice
  include DataMapper::Resource
  
  property :id, Serial
  property :text, String
  
  belongs_to :poll

  has n, :votes

  def deletable_by? (user)
    user == poll.user and votes.blank?
  end

end
