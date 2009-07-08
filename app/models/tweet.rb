class Tweet #address your network. everyone hears it.
  include DataMapper::Resource
  include Paperclip::Resource #for has_attached_file

  # properties "http://datamapper.org/doku.php?id=docs:properties"
  property :id, Serial
  property :content, Text, :nullable=>false, :lazy => false
  property :protected, Boolean, :nullable => false, :default => false #distinguishes a private tweet from a public tweet
  timestamps :at #automatically adds the date-time of creation at the time of saving the object

  has_attached_file :file, # one attachment
      :styles => {:medium => "300x300>", :thumb => "60x60#"},
      :url => "/uploads/:class/:id/:attachment/:style/:basename.:extension",
      :path => "#{Merb.root}/public/uploads/:class/:id/:attachment/:style/:basename.:extension"

  # associations "http://datamapper.org/doku.php?id=docs:associations"
  has n, :comments
  has_tags #the dm-tags plugin.
  belongs_to :made_by, :class_name => 'User', :child_key => [:made_by_id] #obviously a tweet will be made by a user
  has n, :for_users, :class_name => 'User', :through => Resource #a reply could be for many users, whereas message is only for one user
  belongs_to :for_group, :class_name => 'Group', :child_key => [:for_group_id] #if the tweet was meant to be a group message

  default_scope(:default).update(:order => [:created_at.desc]) #sort the tweets in descending order. Read more at: 'http://datamapper.org/doku.php?id=docs:finders#conditions'

  is_indexed :texts => [:content], :values => [[:content, 0, 'content', :string]], :terms => [[:content, 'C', 'content']] #uses dm-xapian plugin for 'full text searching'. Read more at: 'http://github.com/frabcus/acts_as_xapian/tree/master'

  # if the tweet is longer than 120 chars, it returns the first 117 chars appended with ...
  def excerpt
    return content if content.length <= 120
    content[0..116] + '...'
  end

end
