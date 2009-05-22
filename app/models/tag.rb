class Tag
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :length=>32, :nullable=>false
  timestamps :on
  has n, :tweets

end
