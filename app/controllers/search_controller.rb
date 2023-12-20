class SearchController < ApplicationController
  before_action :set_data
  def suggestions
    @users = search_for_users
    @posts = search_for_posts
    puts "heareeeeee"
    puts params[:tag_ids]

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
                 turbo_stream.update('suggestions',
                                     partial: 'search/suggestions',
                                     locals: {
                                       users: @users,
                                       posts: @posts
                                     })
      end
    end
  end
  def search_all
    if params[:query].blank?
      @users =  @search_blank_users
      @posts = @search_blank_posts
    else
      @users = @set_users.limit(6)
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
    tag_ids = params[:tag_ids] || []
    # @set_users = User.where('first_name LIKE ? OR last_name = ?', "%#{params[:query]}%", "%#{params[:query]}%")
    @q_user = User.ransack(first_name_or_last_name_cont: params[:query])
    @q_post = Post.ransack(title_or_description_cont: params[:query])
    @set_users = @q_user.result(distinct: true)
    @set_posts = @q_post.result(distinct: true).joins(:tags).where(tags: { id: tag_ids }).distinct
    @search_blank_users = User.limit(6)
    @search_blank_posts = Post.limit(6)
  end
  def search_params
    params.permit(:term)
  end
  def search_for_users
    if params[:query].blank?
      User.limit(2)
    else
      @set_users
    end
  end

  def search_for_posts
    if params[:query].blank?
      Post.limit(2)
    else
      @set_posts
    end
  end
end
