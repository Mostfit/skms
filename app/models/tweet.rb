class Tweet #address your network. everyone hears it.
  include DataMapper::Resource
  include Paperclip::Resource

  property :id, Serial
  property :content, Text, :nullable=>false, :lazy => false
  property :protected, Boolean, :nullable => false, :default => Proc.new { |r, p| r.for_user ? true:false } #if group is protected, approved = false and vice verca
  timestamps :at

  has_attached_file :file,
      :styles => {:medium => "300x300>", :thumb => "60x60#"},
      :url => "/uploads/:class/:id/:attachment/:style/:basename.:extension",
      :path => "#{Merb.root}/public/uploads/:class/:id/:attachment/:style/:basename.:extension"

  has n, :comments
  has_tags #comes from the dm-tags plugin
  belongs_to :made_by, :class_name => 'User', :child_key => [:made_by_id] 
  belongs_to :for_user, :class_name => 'User', :child_key => [:for_user_id]
  belongs_to :only_for_user, :class_name => 'User', :child_key => [:only_for_user_id]
  belongs_to :only_for_group, :class_name => 'Group', :child_key => [:only_for_group_id]

  default_scope(:default).update(:order => [:created_at.desc]) #this will sort the tweets in descending order by time of creation, when you query for anything

end
