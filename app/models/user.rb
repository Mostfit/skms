# This is a default user class used to activate merb-auth.  Feel free to change from a User to 
# Some other class, or to remove it altogether.  If removed, merb-auth may not work by default.
#
# Don't forget that by default the salted_user mixin is used from merb-more
# You'll need to setup your db as per the salted_user mixin, and you'll need
# To use :password, and :password_confirmation when creating a user
#
# see merb/merb-auth/setup.rb to see how to disable the salted_user mixin
# 
# You will need to setup your database and create a user.
class User
  include DataMapper::Resource
  include Paperclip::Resource
  
  property :id, Serial
  property :name, String
  property :nick, String
  property :email, String, :nullable => false, :format=> :email_address
  property :admin, Boolean, :default => false, :nullable => false

  timestamps :at

  has n, :tweets
  has n, :comments
  has n, :polls
  has n, :votes
  has n, :groups, :through => Resource

  has_attached_file :image,
  :styles => {:medium => "200x200>", :thumb => "60x60#"},
  :url => "/uploads/:class/:id/:attachment/:style/:basename.:extension",
  :path => "#{Merb.root}/public/uploads/:class/:id/:attachment/:style/:basename.:extension",
  :default_url => "/images/no_photo2.jpg"

  validates_is_unique :email
  validates_format :name, :with=>/^[A-Za-z ]+$/
  validates_format :nick, :with=>/^[A-Za-z0-9_-]+$/
  validates_format :email, :format => :email_address
  validates_length :name, :nick, :min_length => 3

  def password_required?; false end 
  
end
