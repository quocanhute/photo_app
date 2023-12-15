class NotificationController < ApplicationController
  before_action :set_notification

  def view_object
    @notification.update!(as_read: true, read_at: Time.zone.now)
    case @notification.object_type
    when "Comment"
      redirect_to post_path(@notification.object.post)
    when "User"
      redirect_to profile_path(@notification.object)
    else
    end
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end
end