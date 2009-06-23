class User
  include DataMapper::Resource
  include Paperclip::Resource
  
  property :id, Serial
  property :name, String,   :format => /^[A-Za-z0-9 ]+$/
  property :nick, String,   :format => /^[A-Za-z0-9_-]+$/, :nullable => false, :unique => true
  property :email, String,  :nullable => false, :format=> :email_address
  property :admin, Boolean, :default => false, :nullable => false
  property :bio, Text

  timestamps :at

  has n, :tweets, :class_name => 'Tweet', :child_key => [:made_by_id]
  has n, :replies, :class_name => 'Reply', :child_key => [:for_id]
  has n, :pm, :class_name => 'PrivateMessage', :child_key => [:for_id]
  has n, :comments
  has n, :polls
  has n, :votes
  has n, :memberships
  has n, :groups, :through => :memberships, :child_key => [:group_id]
  has n, :moderations
  has n, :groups_moderated, :through => :moderations, :child_key => [:group_id]

  has_attached_file :image,
  :styles => {:medium => "300x300>", :thumb => "60x60#"},
  :url => "/uploads/:class/:id/:attachment/:style/:basename.:extension",
  :path => "#{Merb.root}/public/uploads/:class/:id/:attachment/:style/:basename.:extension",
  :default_url => "/images/default.jpg"

  validates_is_unique :email

  def password_required?; false end 

end
