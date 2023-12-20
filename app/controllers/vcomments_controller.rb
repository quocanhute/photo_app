class VcommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create update destroy vote]
  before_action :set_vcomment, only: %i[update destroy vote]
  before_action :set_video, only: %i[destroy create]

  def create
    @vcomment = current_user.vcomments.new(vcomment_params)
    respond_to do |format|
      if @vcomment.check_comment == true
        format.html { redirect_to video_path(params[:video_id]), alert: "Bad word found!!! 😓😓😓"}
      else
        ActiveRecord::Base.transaction do
          if @vcomment.save
            if params[:reply].present?
            #   do noti for comment's user
              message = "#{current_user.username} reply your comment in video #{@video.title.truncate(10)}"
              create_notification_for_comment(@vcomment.parent,message)
            else
              if current_user != @vcomment.video.user
                message = "#{current_user.username} comment in your video #{@video.title.truncate(10)}"
                create_notification_for_post(@vcomment,@video,message)
              end
            end
            format.turbo_stream
          else
            format.html { redirect_to video_path(params[:post_id]), alert: "Comment can't be blank! 😓😓😓"}
          end
        end
      end

    end
  end

  def destroy
    @vcomment = @video.vcomments.find(params[:id])
    @vcomment.destroy

    respond_to do |format|
      format.html {
        flash[:notice] = 'Comment was successfully destroyed.'
        redirect_to video_path(@video)
      }
    end
  end

  def vote
    case params[:type]
    when 'upvote'
      @vcomment.upvote!(current_user)
    when 'downvote'
      @vcomment.downvote!(current_user)
    else
      return redirect_to request.url, alert: "No such vote type"
    end
    respond_to do |format|
      format.html do
        redirect_to @vcomment.video
      end
      format.turbo_stream do
        render turbo_stream: private_stream_comment
      end
    end
  end

  private

  def set_video
    @video = Video.find(params[:video_id])
  end

  def set_vcomment
    @vcomment = Vcomment.find(params[:id])
  end

  def vcomment_params
    params.require(:vcomment).permit(:content, :parent_id).merge(video_id: params[:video_id])
  end

  def private_stream_comment
    private_target = "#{helpers.dom_id(@vcomment)} vcomment_private_likes"
    turbo_stream.replace(private_target,
                         partial: 'likes/private_button_vcomment',
                         locals:{
                           vcomment: @vcomment,
                           user: current_user
                         })
  end

  def create_notification_for_post(vcomment,post,message)
    # Tạo Notification cho comment
    Notification.create(
      sender: current_user,
      receiver: post.user,
      object: vcomment,
      as_read: false,
      content: message
    )
  end

  def create_notification_for_comment(vcomment,message)
    # Tạo Notification cho comment
    Notification.create(
      sender: current_user,
      receiver: vcomment.user,
      object: vcomment,
      as_read: false,
      content: message
    )
  end
end
