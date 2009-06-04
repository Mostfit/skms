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
  
  property :id,         Serial
  property :name, String, :nullable => false
  property :email, String, :nullable => false 
  property :identity_url, String, :nullable => false

  timestamps :at

  has n, :tweets
  has n, :comments

  has_attached_file :image,
      :styles => {:thumb => "100x100"}

  validates_is_unique :identity_url
  validates_is_unique :email

  def password_required?; false end 
  
end
