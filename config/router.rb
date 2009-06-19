# Merb::Router is the request routing mapper for the merb framework.
#
# You can route a specific URL to a controller / action pair:
#
#   match("/contact").
#     to(:controller => "info", :action => "contact")
#
# You can define placeholder parts of the url with the :symbol notation. These
# placeholders will be available in the params hash of your controllers. For example:
#
#   match("/books/:book_id/:action").
#     to(:controller => "books")
#   
# Or, use placeholders in the "to" results for more complicated routing, e.g.:
#
#   match("/admin/:module/:controller/:action/:id").
#     to(:controller => ":module/:controller")
#
# You can specify conditions on the placeholder by passing a hash as the second
# argument of "match"
#
#   match("/registration/:course_name", :course_name => /^[a-z]{3,5}-\d{5}$/).
#     to(:controller => "registration")
#
# You can also use regular expressions, deferred routes, and many other options.
# See merb/specs/merb/router.rb for a fairly complete usage sample.

Merb.logger.info("Compiling routes...")
Merb::Router.prepare do
  resources :tags

  match(%r{^/polls/([a-z]+)$}).to(:controller => 'polls', :action => "[1]").name(:poll_action) #does 'my','closed', etc

  resources :polls do
    resources :poll_choices do
      resources :votes
    end
  end

  resources :events
  resources :groups
  resources :groups
    resources :users
    resources :tweets
    resources :tags
    resources :comments
    # RESTful routes
    # resources :posts
    
    # Adds the required routes for merb-auth using the password slice
    slice(:merb_auth_slice_password, :name_prefix => nil, :path_prefix => "")

    # This is the default route for /:controller/:action/:id
    # This is fine for most cases.  If you're heavily using resource-based
    # routes, you may want to comment/remove this line to prevent
    # clients from calling your create or destroy actions with a GET
    # default_routes
    
    # Change this for your home page to be available at /
    match('/').to(:controller => 'tweets', :action =>'index')
    match('/openid/login').to(:controller => 'users', :action => 'login').name(:openid)
    match('/replies').to(:controller => 'tweets', :action => 'replies').name(:replies)
    match('/search').to(:controller => 'search', :action => 'search').name(:search)
    match("/polls/:id/publish").to(:controller => 'polls', :action => 'publish').name(:publish_poll)
    match("/polls/:id/vote").to(:controller => 'polls', :action => 'vote').name(:vote)
    match("/:nick").to(:controller => 'users', :action => 'profile').name(:profile)
end
