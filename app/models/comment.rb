class Comment
  include DataMapper::Resource
  
  property :id, Serial
  property :content, Text, :nullable=>false
  timestamps :at

  belongs_to :tweet
  belongs_to :user
  belongs_to :poll

end
