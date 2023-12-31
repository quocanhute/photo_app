class SearchController < ApplicationController
  before_action :set_data
  def suggestions
    @users = search_for_users
    @posts = search_for_posts
    @videos = search_for_videos

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
                 turbo_stream.update('suggestions',
                                     partial: 'search/suggestions',
                                     locals: {
                                       users: @users,
                                       posts: @posts,
                                       videos: @videos
                                     })
      end
    end
  end
  def search_all
    if params[:query].blank?
      @users =  @set_users
      @posts = @search_blank_posts
      @videos = @search_blank_videos
    else
      @users = @set_users
      @posts = @set_posts
      @videos = @set_videos
    end

  end

  def show_all_user_search
    if params[:query].blank?
      @users =  User.page(params[:page]).per(12)
    else
      @users = @set_users.page(params[:page]).per(12)
    end
  end

  private
  def set_data
    @q_user = User.ransack(first_name_or_last_name_cont: params[:query])
    @q_post = Post.where(published: true, status: 2).ransack(title_or_description_cont: params[:query])
    @q_video = Video.where(published: true, status: 2).ransack(title_or_description_cont: params[:query])
    @set_users = @q_user.result(distinct: true)
    if params[:tag_ids].present?
      @set_posts = @q_post.result(distinct: true).joins(:tags).where(tags: { id: params[:tag_ids] }).distinct
      @set_videos = @q_video.result(distinct: true).joins(:tags).where(tags: { id: params[:tag_ids] }).distinct
      @search_blank_posts = Post.joins(:tags).where(published: true, status: 2).where(tags: { id: params[:tag_ids] }).limit(10)
      @search_blank_videos = Video.joins(:tags).where(published: true, status: 2).where(tags: { id: params[:tag_ids] }).limit(10)
    else
      @set_posts = @q_post.result(distinct: true).where(published: true, status: 2).distinct
      @set_videos = @q_video.result(distinct: true).where(published: true, status: 2  ).distinct
      @search_blank_posts = Post.where(published: true, status: 2).limit(10)
      @search_blank_videos = Video.where(published: true, status: 2).limit(10)
    end

  end
  def search_params
    params.permit(:term)
  end
  def search_for_users
    @set_users.limit(3)
  end

  def search_for_posts
    if params[:query].blank?
      @search_blank_posts.limit(3)
    else
      @set_posts.limit(3)
    end
  end

  def search_for_videos
    if params[:query].blank?
      @search_blank_videos.limit(3)
    else
      @set_videos.limit(3)
    end
  end
end
