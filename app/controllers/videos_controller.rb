class VideosController < ApplicationController
  before_action :authenticate_user!, only: %i[ index new edit create update destroy vote bookmark]
  before_action :set_video, only: %i[ show edit update destroy publish unpublish vote bookmark action_delete_video]
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

  end

  # POST /photos or /photos.json
  def create
    @video = current_user.videos.build(video_params)

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
    @video.update(published: true, published_at: Time.now)
    unless @video.already_published
      @video.update(already_published: true)
      @video.user.follower.each do |user|
        message = "User #{@video.user.username} just creating a new video"
        create_notification_for_follower(@video,@video.user,user,message)
      end
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [update_action_publish,update_published_at]
      end
    end
  end

  def unpublish
    @video.update(published: false, published_at: nil)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [update_action_publish,update_published_at]
      end
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
      redirect_to root_path, alert: 'Access denied.'
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

  def create_notification_for_follower(video,followee,follower,message)
    # Tạo Notification cho comment
    Notification.create(
      sender: followee,
      receiver: follower,
      object: video,
      as_read: false,
      content: message
    )
  end
end
