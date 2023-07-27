class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followee, class_name: 'User'

  before_save :create_notification
  before_destroy :cleanup_notifications

  private
  def create_notification
    FollowNotification.with(follower: follower, followee: followee).deliver_later(followee)
  end

  def cleanup_notifications
    Notification.where(recipient_id: followee_id).destroy_all
  end

end

