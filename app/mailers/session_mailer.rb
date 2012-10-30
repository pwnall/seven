class SessionMailer < ActionMailer::Base
  include Authpwn::SessionMailer

  def email_verification_subject(token, server_hostname, protocol)
    "#{Course.main.number} e-mail verification"
  end
  
  def email_verification_from(token, server_hostname, protocol)
    %Q|"#{Course.main.number} staff" <#{Course.main.email}>|
  end  

  def reset_password_subject(token, server_hostname, protocol)
    "#{Course.main.number} password reset"
  end
  
  def reset_password_from(token, server_hostname, protocol)
    %Q|"#{Course.main.number} staff" <#{Course.main.email}>|
  end
  # Add your extensions to the SessionMailer class here.  
end
