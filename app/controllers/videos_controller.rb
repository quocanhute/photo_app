class VideosController < ApplicationController
  before_action :authenticate_user!, only: %i[ index new edit create update destroy vote bookmark]
  before_action :set_video, only: %i[ show edit update destroy publish unpublish vote bookmark action_delete_video]
  before_action :check_authorization, only: [:show]
  before_action :check_video_ownership, only: [:edit, :update, :destroy]

  # GET /photos or /photos.json
  def index
    @videos = current_user.videos.page(params[:page]).per(8)
  end

  # GET /photos/1 or /photos/1.json
  def show
    if current_user
      @video.increment!(:total_views)
    end
  end

  # GET /photos/new
  def new
    @video = current_user.videos.build
  end

  # GET /photos/1/edit
  def edit
    @video_status = @video.status
  end

  # POST /photos or /photos.json
  def create
    @video = current_user.videos.build(video_params)
    @video_status = @video.status
    respond_to do |format|
      if @video.save
        format.html { redirect_to edit_video_path(@video), notice: "Video was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photos/1 or /photos/1.json
  def update
    @video_status = @video.status
    respond_to do |format|
      if @video.update(video_params)
        format.html {
          flash[:notice] = 'Video was successfully updated.'
          redirect_to edit_video_path(@video)
        }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1 or /photos/1.json
  def destroy
    @video.destroy

    respond_to do |format|
      format.html { redirect_to videos_url, notice: "Video was successfully destroyed." }
    end
  end

  def publish
    if @video.accept?
      @video.update(published: true, published_at: Time.now)
      respond_to do |format|
        format.html { redirect_to edit_video_url(@video), notice: "Your video was successfully published." }
      end
    else
      @video.update(status: 1, published_at: Time.now)
      @video_status = @video.status
      User.admin_and_censor.each do |user|
        message = "Need to check a video #{@video.user.username} just published!!!"
        create_notification_for_censor(@video.user,user,@video,message)
      end
      respond_to do |format|
        format.html { redirect_to edit_video_url(@video), notice: "Your video need to check before publish!" }
      end
    end


  end

  def unpublish
    @video.update(published: false, published_at: nil)
    @video_status = @video.status
    respond_to do |format|
      format.html { redirect_to edit_video_url(@video), notice: "Your video was successfully unpublished." }
    end
  end

  def bookmark
    @video.bookmark!(current_user)
    respond_to do |format|
      format.html do
        redirect_to @video
      end
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@video, partial: "videos/video", locals: {video: @video})
      end
    end
  end

  def vote
    case params[:type]
    when 'upvote'
      @video.upvote!(current_user)
    when 'downvote'
      @video.downvote!(current_user)
    else
      return redirect_to request.url, alert: "No such vote type"
    end
    respond_to do |format|
      format.html do
        redirect_to @video
      end
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@video, partial: "videos/video", locals: {video: @video})
      end
    end
  end

  def action_delete_video
  end

  private

  def set_video
    @video = Video.find(params[:id])
  end


  def video_params
    params.require(:video).permit(:title, :description, :header_image, :video, :tag_list)
  end
  
  def check_video_ownership
    video = Video.find_by(id: params[:id])
    if video && video.user_id == current_user.id
    else
      redirect_to '/403'
    end
  end

  def update_action_publish
    private_target = ".#{helpers.dom_id(@video)}_publish_video"
    turbo_stream.replace_all(private_target,
                             partial: 'videos/publisher_button',
                             locals: {
                               video: @video
                             })
  end

  def update_published_at
    private_target = ".#{helpers.dom_id(@video)}_published_at"
    turbo_stream.replace_all(private_target,
                             partial: 'videos/published_at',
                             locals: {
                               video: @video
                             })
  end

  def create_notification_for_censor(sender,receiver,video,message)
    # Tạo Notification cho comment
    Notification.create(
      sender: sender,
      receiver: receiver,
      object: video,
      as_read: false,
      content: message
    )
  end

  def check_authorization
    video = Video.find_by(id: params[:id])
    if video
      if video.accept?
      elsif current_user
        if video.user_id == current_user.id || current_user.admin? || current_user.censor?
        else
          redirect_to '/403'
        end
      else
        redirect_to '/403'
      end

    else
      redirect_to '/404'
    end
  end
end
