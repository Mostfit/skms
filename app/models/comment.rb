class Comment
  include DataMapper::Resource
  
  property :id, Serial
  property :content, String, :length=>100, :nullable=>false
  property :created, DateTime

  belongs_to :post

end
