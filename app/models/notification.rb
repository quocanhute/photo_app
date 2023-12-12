class Notification < ApplicationRecord
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
  belongs_to :object, polymorphic: true

  scope :unread, -> { where(as_read: false) }
  scope :read, -> { where(as_read: true) }

  after_create_commit { broadcast_notifications }

  private

  def broadcast_notifications
    broadcast_replace_to "notifications_#{receiver.id}",
                         target: "notifications_#{receiver.id}",
                         partial: 'shared/notifications',
                         locals: {user: receiver}
  end
end

