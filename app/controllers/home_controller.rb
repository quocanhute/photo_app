class HomeController < ApplicationController
  def index
  end

  def index_show_video
    data_video = set_data_video
    if current_user
      case params[:index]
      when "top"
        @pagy, @videos = pagy(data_video.joins(:tags).where(tags: { id: current_user.tags }).where(published: true).distinct.order(cached_weighted_like_score: :desc,total_views: :desc), items: VIDEOS_PER_PAGE)
      when "oldest"
        @pagy, @videos = pagy(data_video.joins(:tags).where(tags: { id: current_user.tags }).where(published: true).distinct.order(created_at: :asc,total_views: :desc), items: VIDEOS_PER_PAGE)
      when "newest"
        @pagy, @videos = pagy(data_video.joins(:tags).where(tags: { id: current_user.tags }).where(published: true).distinct.order(created_at: :desc,total_views: :desc), items: VIDEOS_PER_PAGE)
      else
        @pagy, @videos = pagy(data_video.joins(:tags).where(tags: { id: current_user.tags }).where(published: true).order(total_views: :desc).distinct, items: VIDEOS_PER_PAGE)
      end
    else
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
    end
    # sleep(1)
    respond_to do |format|
      format.html # GET
      format.turbo_stream # POST
    end
  end

  def index_show_post
    data_post = set_data_post
    if current_user
      case params[:index]
      when "top"
        @pagy, @posts = pagy(data_post.joins(:tags).where(tags: { id: current_user.tags }).where(published: true).distinct.order(cached_weighted_like_score: :desc,total_views: :desc), items: POSTS_PER_PAGE)
      when "oldest"
        @pagy, @posts = pagy(data_post.joins(:tags).where(tags: { id: current_user.tags }).where(published: true).distinct.order(created_at: :asc,total_views: :desc), items: POSTS_PER_PAGE)
      when "newest"
        @pagy, @posts = pagy(data_post.joins(:tags).where(tags: { id: current_user.tags }).where(published: true).distinct.order(created_at: :desc,total_views: :desc), items: POSTS_PER_PAGE)
      else
        @pagy, @posts = pagy(data_post.joins(:tags).where(tags: { id: current_user.tags }).where(published: true).order(total_views: :desc).distinct, items: POSTS_PER_PAGE)
      end
    else
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
    end
    # sleep(1)
    respond_to do |format|
      format.html # GET
      format.turbo_stream # POST
    end
  end


  private

  def set_data_post
    if params[:query].present?
      Post.where(published: true, status: 2).ransack(title_or_description_cont: params[:query]).result(distinct: true)
    else
      Post.where(published: true, status: 2)
    end
  end

  def set_data_video
    if params[:query].present?
      Video.where(published: true, status: 2).ransack(title_or_description_cont: params[:query]).result(distinct: true)
    else
      Video.where(published: true, status: 2)
    end
  end
end