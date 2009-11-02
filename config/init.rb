# Go to http://wiki.merbivore.com/pages/init-rb
 
require 'config/dependencies.rb'
 
use_orm :datamapper
use_test :rspec
use_template_engine :haml
 
Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper
  
  # cookie session store configuration
  c[:session_secret_key]  = 'c6cf15bc8aa0697b28066b95ad0ebdbd2a99f1c6'  # required for cookie session store
  c[:session_id_key] = '_twitter_session_id' # cookie session id key, defaults to "_session_id"
end
 
Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
end
 
Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
	OpenID::Util.logger = Merb.logger
	ENV['http_proxy'] = 'http://144.16.192.245:8080' # <- set your http_proxy env var
	OpenID.fetcher_use_env_http_proxy
end
