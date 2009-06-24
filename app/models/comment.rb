class Comment
  include DataMapper::Resource
  include Paperclip::Resource
  
  property :id, Serial
  property :content, Text, :nullable=>false
  timestamps :at

  belongs_to :tweet
  belongs_to :user
  belongs_to :poll

  has_attached_file :file,
      :styles => {:medium => "300x300>", :thumb => "60x60#"},
      :url => "/uploads/:class/:id/:attachment/:style/:basename.:extension",
      :path => "#{Merb.root}/public/uploads/:class/:id/:attachment/:style/:basename.:extension"

  default_scope(:default).update(:order => [:created_at.desc]) #this will sort the comments in descending order by time of creation, when you query for anything

end
