# To deliver this notification:
#
# FollowNotification.with(post: @post).deliver_later(current_user)
# FollowNotification.with(post: @post).deliver(current_user)

class FollowNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  # param :post

  # Define helper methods to make rendering easier.
  #
  def message
    @follower = User.find(params[:follower][:id])
    @followee = User.find(params[:followee][:id])
    "Dear #{@followee.username},#{@follower.username} just follow you!!"
  end
  #
  def url
    post_path(User.find(params[:followee][:id]))
  end
end
