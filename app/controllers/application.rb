require 'cgi'
class Application < Merb::Controller
  before :ensure_authenticated
  def ensure_is_admin
    raise NotPrivileged unless session.user.right.index(:admin)
  end

  def add_event(user, verb, thing, link)
    @object = eval "#{link.split('/')[-2].singular.camel_case}.get(#{link.split('/')[-1]})"
    link = "<a href='http://loyola90.net#{link}'>#{thing}</a>"
    message = "#{user.name} #{verb} #{link}"
    email_subject = "#{user.name} #{verb} #{thing}"
    e = Event.new(:message => CGI.escapeHTML(message), :user_id => user.id)
    e.save
    Merb.run_later do
      email_users = User.all(:activation_string => nil, :notify_by_email => true)
      template_filename = "notify_#{verb.downcase.gsub(' ','_')}_#{@object.class.to_s.downcase}"
      template = File.exist?("app/mailers/views/mail_mailer/#{template_filename}") ? template_filename.to_sym : :default_notification
      email_users.each do |user|
        debugger
        Merb.logger.info "Sending mail to #{user.email}"
        send_mail(MailMailer, template, {
                 :from => 'loyola90@loyola90.net',
                 :to   => user.email,
                 :subject => "[loyola90] #{email_subject}",
               }, {:object => @object, :user => user, :link => link, :verb => verb, :thing => thing, :message => message})
      end
    end
  end
end
