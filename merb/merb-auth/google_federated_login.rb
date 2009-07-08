# The google federated login is based on Google's implementation of Open ID. 
# http://code.google.com/apis/accounts/docs/OpenID.html
# Google uses AX response instead of the Sreg response.
#
# This code is based on the original basic_openid strategy. I have modified the code to use AX response instead of SREG response.
# Overwrite the on_sucess!, on_failure!, on_setup_needed!, and on_cancel! to customize events.
#
# == Requirments
#
# === Routes:
#   :openid - an action that is accessilbe via http GET and protected via ensure_authenticated
#
# === Attributes
#   :identity_url - A string for holding the identity_url associated with this user (overwritable)
#
# install the ruby-openid gem
require 'openid'
require 'openid/store/filesystem'
require 'openid/extensions/ax'

class Merb::Authentication
  module Strategies
    module Basic
      class OpenID < Merb::Authentication::Strategy
        def run!
          if request.params[:'openid.mode']
            response = consumer.complete(request.send(:query_params), "#{request.protocol}://#{request.host}" + request.path)
            case response.status.to_s
            when 'success'
              ax_response = ::OpenID::AX::FetchResponse.from_success_response(response)
              result = on_success!(response, ax_response)
              Merb.logger.info "\n\n#{result.inspect}\n\n"
              result
            when 'failure'
              on_failure!(response)
            when  'setup_needed'
              on_setup_needed!(response)
            when 'cancel'
              on_cancel!(response)
            end
          elsif identity_url = params[:openid_url]
            begin
              openid_request = consumer.begin(identity_url)
              openid_ax = ::OpenID::AX::FetchRequest.new
              email_attr = ::OpenID::AX::AttrInfo.new('http://schema.openid.net/contact/email', 'email', true)
              openid_ax.add(email_attr)
              openid_request.add_extension(openid_ax)
              redirect!(openid_request.redirect_url("#{request.protocol}://#{request.host}", openid_callback_url))
            rescue ::OpenID::OpenIDError => e
              request.session.authentication.errors.clear!
              request.session.authentication.errors.add(:openid, 'The OpenID verification failed')
              nil
            end
          end
        end # run!
        
        
        # Overwrite this to add extra options to the OpenID request before it is made.
        # 
        # @example request.return_to_args["remember_me"] = 1 # remember_me=1 is added when returning from the OpenID provider.
        # 
        # @api overwritable
        def customize_openid_request!(openid_request)
        end
        
        # Used to define the callback url for the openid provider.  By default it
        # is set to the named :openid route.
        # 
        # @api overwritable
        def openid_callback_url
          "#{request.protocol}://#{request.host}#{Merb::Router.url(:openid)}"
        end
        
        # Overwrite the on_success! method with the required behavior for successful logins
        #
        # @api overwritable
        def on_success!(response, ax_response)
          email=ax_response.data["http://schema.openid.net/contact/email"]
          if user = find_user_by_email(email)
            user
          else
            nick = email.to_s.sub(/\@\w+\.\w+/,'')
            user = user_class.new({:email => email, :nick => nick})
            user.save
            user
          end
        end
        
        # Overwrite the on_failure! method with the required behavior for failed logins
        #
        # @api overwritable
        def on_failure!(response)
          session.authentication.errors.clear!
          session.authentication.errors.add(:openid, 'OpenID verification failed, maybe the provider is down? Or the session timed out')
          nil
        end
        
        #
        # @api overwritable
        def on_setup_needed!(response)
          request.session.authentication.errors.clear!
          request.session.authentication.errors.add(:openid, 'OpenID does not seem to be configured correctly')
          nil
        end
        
         #
         # @api overwritable
        def on_cancel!(response)
          request.session.authentication.errors.clear!
          request.session.authentication.errors.add(:openid, 'OpenID rejected our request')
          nil
        end
        
        #
        # @api overwritable
        def required_reg_fields
          ['nickname', 'email']
        end
        
        #
        # @api overwritable
        def optional_reg_fields
          ['fullname']
        end
        
        # Overwrite this to support an ORM other than DataMapper
        #
        # @api overwritable
        def find_user_by_email(email)
          user_class.first(:email => email)
        end
        
        # Overwrite this method to set your store
        #
        # @api overwritable
        def openid_store
          ::OpenID::Store::Filesystem.new("#{Merb.root}/tmp/openid")
        end
        
        private
        def consumer
          @consumer ||= ::OpenID::Consumer.new(request.session, openid_store)
        end
              
      end # OpenID
    end # Basic
  end # Strategies
end # Merb::Authentication
