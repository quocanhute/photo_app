# To deliver this notification:
#
# LikeAlbumNotification.with(post: @post).deliver_later(current_user)
# LikeAlbumNotification.with(post: @post).deliver(current_user)

class LikeAlbumNotification < Noticed::Base
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
    @user_has_album_liked = User.find(params[:liked_album_user].user.id)
    @album = Album.find(params[:liked_album_user][:id])
    "Dear #{@user_has_album_liked.username},#{@liked_user.username} just like album #{@album.title}!!"
  end

  def url
    post_path(User.find(params[:liked_album_user].user.id))
  end
end
