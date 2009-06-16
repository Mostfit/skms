class Event
  include DataMapper::Resource
  
  property :id, Serial
  property :created_at, DateTime
  property :message, Text, :length => 255
  belongs_to :user

end
