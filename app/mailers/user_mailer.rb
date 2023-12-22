class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.new_user_email.subject
  #
  def new_user_email(user)
    @user = user
    mail(to: user.email, subject: 'Welcome to MyBlog!!!')
  end

  def ban_user_email(user)
    @user = user
    mail(to: user.email, subject: 'You were banned on MyBlog')
  end

  def unban_user_email(user)
    @user = user
    mail(to: user.email, subject: 'You were unbanned on MyBlog')
  end
end
