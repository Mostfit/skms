class Event
  include DataMapper::Resource
  
  property :id, Serial
  property :description, Text

  timestamps :at  

  belongs_to :user

end
