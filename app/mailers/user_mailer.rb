class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.new_user_email.subject
  #
  def new_user_email(user)
    @user = user
    mail(to: user.email, subject: 'Welcome to PhotoBook!!!')
  end
end
