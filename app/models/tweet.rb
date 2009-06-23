class Tweet #address your network. everyone hears it.
  include DataMapper::Resource
  include Paperclip::Resource

  property :id, Serial
  property :discriminator, Discriminator, :default => 'Tweet', :nullable => false
  property :content, Text, :nullable=>false, :lazy => false
  timestamps :at

  has_attached_file :file,
      :styles => {:medium => "300x300>", :thumb => "60x60#"},
      :url => "/uploads/:class/:id/:attachment/:style/:basename.:extension",
      :path => "#{Merb.root}/public/uploads/:class/:id/:attachment/:style/:basename.:extension"

  has n, :comments
  has_tags #comes from the dm-tags plugin
  belongs_to :made_by, :class_name => 'User', :child_key => [:made_by_id] 

  default_scope(:default).update(:order => [:created_at.desc]) #this will sort the tweets in descending order by time of creation, when you query for anything

end

class Reply < Tweet #address a person. everyone hears it.

  belongs_to :for, :class_name => 'User', :child_key => [:for_id]

end

class PrivateMessage < Tweet #whisper to a person. only he hears it.

  belongs_to :for, :class_name => 'User', :child_key => [:for_id]

  #a user is authorised to see the private messages if it is 'for' him
  def is_authorised? user_id
    self.for_id == user_id
  end

end

class GroupMessage < Tweet #speak only to the group. only group members hear it.

  belongs_to :for, :class_name => 'Group', :child_key => [:for_id]

  #a user is authorised to see the group messages if he is a part of the group
  def is_authorised? user_id
    return true unless Membership.all(:group_id => self.for_id, :user_id => user_id)
  end

end
