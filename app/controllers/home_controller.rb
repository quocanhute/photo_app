class HomeController < ApplicationController
  def index
  end

  def index_show_video
    @pagy, @videos = pagy_countless(Video.where(published: true), items:VIDEOS_PER_PAGE)
    # sleep(1)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def index_show_post
    data_post = set_data_post
    case params[:index]
    when "top"
      @pagy, @posts = pagy(data_post.joins(:tags).where(tags: { id: current_user.tags }).where(published: true).distinct.order(cached_weighted_like_score: :desc), items: POSTS_PER_PAGE)
    when "oldest"
      @pagy, @posts = pagy(data_post.joins(:tags).where(tags: { id: current_user.tags }).where(published: true).distinct.order(created_at: :asc), items: POSTS_PER_PAGE)
    when "newest"
      @pagy, @posts = pagy(data_post.joins(:tags).where(tags: { id: current_user.tags }).where(published: true).distinct.order(created_at: :desc), items: POSTS_PER_PAGE)
    else
      @pagy, @posts = pagy(data_post.joins(:tags).where(tags: { id: current_user.tags }).where(published: true).distinct, items: POSTS_PER_PAGE)
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
      Post.ransack(title_or_description_cont: params[:query]).result(distinct: true)
    else
      Post
    end
  end
end