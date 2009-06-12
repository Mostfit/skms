class Group
  include DataMapper::Resource
  include Paperclip::Resource
  
  property :id, Serial
  property :name, String, :nullable => false
  property :purpose, Text
  property :protected, Boolean, :default => false, :nullable => false

  has n,   :memberships
  has n,   :members, :class_name => 'User', :through => :memberships, :child_key => [:user_id]
  has n,   :moderators, :class_name => 'User', :through => Resource

  has_attached_file :image,
    :styles => {:medium => "300x300>", :thumb => "60x60#"},
    :url => "/uploads/:class/:id/:attachment/:style/:basename.:extension",
    :path => "#{Merb.root}/public/uploads/:class/:id/:attachment/:style/:basename.:extension",
    :default_url => "/images/default_group.jpg"

end

class Membership
  include DataMapper::Resource

  property :approved, Boolean
  property :user_id,  Integer, :key => true
  property :group_id,  Integer, :key => true

  belongs_to :group
  belongs_to :member, :class_name => 'User', :child_key => [:user_id]

end
