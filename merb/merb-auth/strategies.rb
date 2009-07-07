# This file is specifically for you to define your strategies 
#
# You should declare you strategies directly and/or use 
# Merb::Authentication.activate!(:label_of_strategy)
#
# To load and set the order of strategy processing

Merb::Slices::config[:"merb-auth-slice-password"][:no_default_strategies] = true
Merb::Authentication.register(:google_federated_login, "#{Merb.root}/google_federated_login.rb")
Merb::Authentication.activate!(:google_federated_login)

#Merb::Authentication.activate!(:default_password_form)
#Merb::Authentication.activate!(:default_basic_auth)
