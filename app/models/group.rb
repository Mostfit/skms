class Group
  include DataMapper::Resource
  include Paperclip::Resource
  
  property :id, Serial
  property :name, String, :nullable => false
  property :description, Text, :lazy => false
  property :protected, Boolean, :default => false, :nullable => false

  timestamps :at

  has n,   :memberships
  has n,   :members, :through => :memberships, :child_key => [:user_id]
  has n,   :moderations
  has n,   :moderators, :through => :moderations, :child_key => [:user_id]
  has n,   :gms, :class_name => 'GroupMessage', :child_key => [:for_id]
  has_tags #comes from the dm-tags plugin

  has_attached_file :image,
    :styles => {:medium => "300x300>", :thumb => "60x60#"},
    :url => "/uploads/:class/:id/:attachment/:style/:basename.:extension",
    :path => "#{Merb.root}/public/uploads/:class/:id/:attachment/:style/:basename.:extension",
    :default_url => "/images/default_group.jpg"

  default_scope(:default).update(:order => [:created_at.desc]) #this will sort the tweets in descending order by time of creation, when you query for anything

  def is_moderated?
    self.protected
  end

  def moderators #returns all the moderators of the group
    User.all 'moderations.group_id' => self.id
  end

  def members #returns all the members of the group
    User.all 'memberships.group_id' => self.id, 'memberships.approved' => true
  end

  def owner #returns the owner of the group
    User.first 'moderations.group_id' => self.id, 'moderations.owner' => true
  end

  def pending_members #returns all the members of the group whose membership is pending
    User.all 'memberships.group_id' => self.id, 'memberships.approved' => false
  end

end

class Membership
  include DataMapper::Resource

  property :approved, Boolean, :nullable => false, :default => Proc.new { |r, p| not Group.get(r.group_id).protected? } #if group is protected, approved = false and vice verca
  property :user_id,  Integer, :key => true
  property :group_id,  Integer, :key => true

  belongs_to :group, :child_key => [:group_id]
  belongs_to :member, :class_name => 'User', :child_key => [:user_id]

  def can_be_approved_by? user_id
    moderations = Moderation.all :group_id => self.group_id, :user_id => user_id
    return true unless moderations
  end

end

class Moderation
  include DataMapper::Resource

  property :user_id,  Integer, :key => true
  property :group_id,  Integer, :key => true
  property :owner, Boolean, :default => false

  belongs_to :group, :child_key => [:group_id]
  belongs_to :moderator, :class_name => 'User', :child_key => [:user_id]

end
