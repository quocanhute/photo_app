# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/new_user_email
  def new_user_email
    user = User.new(first_name: "Ta",last_name:"Anh",email: "dean@example.com", password: "password", password_confirmation: "password")
    UserMailer.new_user_email(user)
  end

end
