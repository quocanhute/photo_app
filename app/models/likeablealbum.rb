class Likeablealbum < ApplicationRecord
  belongs_to :user
  belongs_to :album

  before_save :create_notification
  before_destroy :cleanup_notifications

  private
  def create_notification
    LikeAlbumNotification.with(liked_user: user, liked_album_user: album).deliver_later(album.user)
  end

  def cleanup_notifications
    Notification.where(recipient_id: album.user).destroy_all
  end
end
