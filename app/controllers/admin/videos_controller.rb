class Admin::VideosController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin

  def index
    data_video = set_data_video
    @videos = data_video.where(status: :in_queue).order(created_at: :desc).page(params[:page]).per(10)
  end

  def action_accept_video
    @video = Video.find(params[:id])
  end

  def action_refuse_video
    @video = Video.find(params[:id])
  end

  def accept_video
    ActiveRecord::Base.transaction do
      @video = Video.find(params[:id])
      @video.update_columns(published: true,status: 2)
      Notification.create(
        sender: current_user,
        receiver: @video.user,
        object: @video,
        as_read: false,
        content: "Your video name #{@video.title} successfully accept!"
      )
      @video.user.follower.each do |user|
        message = "User #{@video.user.username} just creating a new videos!"
        Notification.create(
          sender: @video.user,
          receiver: user,
          object: @video,
          as_read: false,
          content: message
        )
      end
    end
    respond_to do |format|
      format.html { redirect_to admin_videos_url, :notice => 'Video was successfully accept.'  }
    end
  end

  def refuse_video
    ActiveRecord::Base.transaction do
      @video = Video.find(params[:id])
      @video.update_columns(status: 3,published: false, published_at: nil)
      Notification.create(
        sender: current_user,
        receiver: @video.user,
        object: @video,
        as_read: false,
        content: "Your video name #{@video.title} was refuse!",
        status: 1
      )
    end

    respond_to do |format|
      format.html { redirect_to admin_videos_url, :notice => 'Video was successfully refuse.'  }
    end
  end

  private

  def authorize_admin
    unless current_user&.admin? || current_user&.censor?
      redirect_to '/403'
    end
  end

  def set_data_video
    if params[:query_admin_video].present?
      Video.ransack(title_or_description_cont: params[:query_admin_video]).result(distinct: true)
    else
      Video
    end
  end
end
