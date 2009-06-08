class Tag
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :length=>32, :nullable=>false
  timestamps :on
  has n, :tweets, :through=>Resource

  validates_format :name, :with=>/^[A-Za-z0-9_-]+$/
  validates_length :name, :min => 3

end
