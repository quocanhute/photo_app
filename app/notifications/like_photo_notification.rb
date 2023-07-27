# To deliver this notification:
#
# LikePhotoNotification.with(post: @post).deliver_later(current_user)
# LikePhotoNotification.with(post: @post).deliver(current_user)

class LikePhotoNotification < Noticed::Base
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
    @liked_user = User.find(params[:liked_user][:id])
    @user_has_photo_liked = User.find(params[:liked_photo_user].user.id)
    @photo = Photo.find(params[:liked_photo_user][:id])
    "Dear #{@user_has_photo_liked.username},#{@liked_user.username} just like photo #{@photo.title}!!"
  end

  def url
    post_path(User.find(params[:liked_photo_user].user.id))
  end
end
