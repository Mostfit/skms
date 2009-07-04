class NotifyMailer < Merb::MailController

  def notify_on_event
    @user = session.user
    render_mail
  end
  
end
