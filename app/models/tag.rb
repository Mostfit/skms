class Tag
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :length=>32, :nullable=>false
  has n, :tweets

end
