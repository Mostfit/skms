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
  
  property :id,         Serial
  property :login,      String
  property :first_name, String,   :nullable=>false
  property :last_name,  String,   :nullable=>false
  property :created_at, DateTime, :nullable=>false
  property :admin,      Boolean,  :nullable=>false, :default=>false

  has n, :tweets
  has n, :comments

  validates_format :login, :with=>/^[A-Za-z0-9_]+$/
  validates_length :login, :min=>3
  
  def admin?
    self.admin==true
  end
  
end
