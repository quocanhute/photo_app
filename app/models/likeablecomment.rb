class Likeablecomment < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  # before_save :create_notification
  # before_destroy :cleanup_notifications
  # private
  # def create_notification
  #   LikePhotoNotification.with(liked_user: user, liked_photo_user: photo).deliver_later(photo.user)
  # end
  #
  # def cleanup_notifications
  #   Notification.where(recipient_id: photo.user).destroy_all
  # end
end
