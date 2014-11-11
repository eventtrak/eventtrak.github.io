class SignupMailer < ActionMailer::Base
  default from: "\"Tunetap Notification\" <thetap@tunetap.com>"

  def new_signup(contact)
    @contact = contact
    mail to: 'feifan@tunetap.com', subject: 'New signup on Tunetap'
  end
end
