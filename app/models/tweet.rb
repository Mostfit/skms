class Tweet
  include DataMapper::Resource
  include Paperclip::Resource

  property :id, Serial
  property :discriminator, Discriminator, :default => 'Tweet', :nullable => false
  property :content, Text, :nullable=>false
  timestamps :at

  has_attached_file :file,
      :styles => {:medium => "300x300>", :thumb => "60x60#"},
      :url => "/uploads/:class/:id/:attachment/:style/:basename.:extension",
      :path => "#{Merb.root}/public/uploads/:class/:id/:attachment/:style/:basename.:extension"

  has n, :comments
  has n, :tags, :through=>Resource
  belongs_to :made_by, :class_name => 'User', :child_key => [:made_by_id] 

end

class Reply < Tweet

  belongs_to :for, :class_name => 'User', :child_key => [:for_id]

end

