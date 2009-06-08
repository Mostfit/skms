class Vote
  include DataMapper::Resource
  
  property :id, Serial

  belongs_to :poll_choice
  belongs_to :user

end
