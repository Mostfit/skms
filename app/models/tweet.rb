class Tweet
  include DataMapper::Resource
  include Paperclip::Resource

  property :id, Serial
  property :content, Text, :nullable=>false
  property :created, DateTime, :nullable=>false
  
  has_attached_file :file,
      :styles => {:medium => "300x300>", :thumb => "60x60#"},
      :url => "/uploads/:class/:id/:attachment/:style/:basename.:extension",
      :path => "#{Merb.root}/public/uploads/:class/:id/:attachment/:style/:basename.:extension"
  has n, :comments
  has n, :tags
  belongs_to :user
  
end
