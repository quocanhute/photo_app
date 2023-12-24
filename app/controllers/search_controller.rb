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
      @users =  @search_blank_users
      @posts = @search_blank_posts
      @videos = @search_blank_videos
    else
      @users = @set_users.limit(6)
      @posts = @set_posts.limit(6)
      @videos = @set_videos.limit(6)

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


    # @set_users = User.where('first_name LIKE ? OR last_name = ?', "%#{params[:query]}%", "%#{params[:query]}%")
    @q_user = User.ransack(first_name_or_last_name_cont: params[:query])
    @q_post = Post.ransack(title_or_description_cont: params[:query])
    @q_video = Video.ransack(title_or_description_cont: params[:query])
    @set_users = @q_user.result(distinct: true)
    if params[:tag_ids].present?
      @set_posts = @q_post.result(distinct: true).joins(:tags).where(tags: { id: params[:tag_ids] }).where(published: true).distinct
      @set_videos = @q_video.result(distinct: true).joins(:tags).where(tags: { id: params[:tag_ids] }).where(published: true).distinct

    else
      @set_posts = @q_post.result(distinct: true).where(published: true).distinct
      @set_videos = @q_video.result(distinct: true).where(published: true).distinct
    end
    @search_blank_users = User.limit(6)
    @search_blank_posts = Post.limit(6)
    @search_blank_videos = Video.limit(6)
  end
  def search_params
    params.permit(:term)
  end
  def search_for_users
    if params[:query].blank?
      User.joins(:tags).where(tags: { id: params[:tag_ids] }).limit(3)
    else
      @set_users.limit(3)
    end
  end

  def search_for_posts
    if params[:query].blank?
      Post.joins(:tags).where(tags: { id: params[:tag_ids] }).limit(3)
    else
      @set_posts.limit(3)
    end
  end

  def search_for_videos
    if params[:query].blank?
      Video.joins(:tags).where(tags: { id: params[:tag_ids] }).limit(3)
    else
      @set_videos.limit(3)
    end
  end
end
