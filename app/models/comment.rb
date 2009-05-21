class Comment
  include DataMapper::Resource
  
  property :id, Serial
  property :content, String, :length=>100, :nullable=>false
  property :created, DateTime

  belongs_to :tweet
  belongs_to :user

  validates_format :with=>/^[A-Za-z0-9_*:)(-]+$/

end
