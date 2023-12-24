class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @follower = current_user.follower
  end

  def following_users
    @followee = current_user.followee
  end

  def following_tags
    @tags = current_user.tags
  end

  def posts_bookmark
    data_post = set_data_post
    case params[:index]
    when "top"
      @pagy, @posts = pagy(data_post.where(published: true).distinct.order(cached_weighted_like_score: :desc,total_views: :desc), items: POSTS_PER_PAGE)
    when "oldest"
      @pagy, @posts = pagy(data_post.where(published: true).distinct.order(created_at: :asc,total_views: :desc), items: POSTS_PER_PAGE)
    when "newest"
      @pagy, @posts = pagy(data_post.where(published: true).distinct.order(created_at: :desc,total_views: :desc), items: POSTS_PER_PAGE)
    else
      @pagy, @posts = pagy(data_post.where(published: true).order(total_views: :desc).distinct, items: POSTS_PER_PAGE)
    end
    # sleep(1)
    respond_to do |format|
      format.html # GET
      format.turbo_stream # POST
    end
  end

  def videos_bookmark
    data_video = set_data_video
    case params[:index]
    when "top"
      @pagy, @videos = pagy(data_video.where(published: true).distinct.order(cached_weighted_like_score: :desc,total_views: :desc), items: VIDEOS_PER_PAGE)
    when "oldest"
      @pagy, @videos = pagy(data_video.where(published: true).distinct.order(created_at: :asc,total_views: :desc), items: VIDEOS_PER_PAGE)
    when "newest"
      @pagy, @videos = pagy(data_video.where(published: true).distinct.order(created_at: :desc,total_views: :desc), items: VIDEOS_PER_PAGE)
    else
      @pagy, @videos = pagy(data_video.where(published: true).order(total_views: :desc).distinct, items: VIDEOS_PER_PAGE)
    end
    # sleep(1)
    respond_to do |format|
      format.html # GET
      format.turbo_stream # POST
    end
  end

  def notifications
    @notifications = current_user.received_notifications.order(created_at: :desc).page(params[:page]).per(15)
  end

  private

  def set_data_post
    if params[:query].present?
      Post.bookmarked_by_user(current_user).ransack(title_or_description_cont: params[:query]).result(distinct: true)
    else
      Post.bookmarked_by_user(current_user)
    end
  end

  def set_data_video
    if params[:query].present?
      Video.bookmarked_by_user(current_user).ransack(title_or_description_cont: params[:query]).result(distinct: true)
    else
      Video.bookmarked_by_user(current_user)
    end
  end
end
