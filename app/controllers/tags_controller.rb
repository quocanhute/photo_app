class TagsController < ApplicationController
  before_action :set_tag, only: %i[ show edit update destroy added_tag show_video]
  before_action :authorize_admin, only: %i[ edit update ]
  def index
    @tags = Tag.left_joins(:taggings).group(:id, :name, :detail).order('count(taggings.id) desc')
  end

  def show
    # @posts = Post.where(published: true).tagged_with(@tag.name)
    @user_with_tag = true
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

  def show_video
    @user_with_tag = true
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

  def edit
  end

  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html {
          flash[:notice] = 'Tag was successfully updated.'
          redirect_to tag_path(@tag)
        }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def added_tag
    current_user.add_tag(@tag)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: private_stream_tag
      end
    end
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:detail, :tag_image)
  end

  def private_stream_tag
    private_target = "#{helpers.dom_id(@tag)} private_added_tag"
    turbo_stream.replace(private_target,
                         partial: 'tags/added_button',
                         locals:{
                           tag: @tag,
                           added_status: current_user.tag_added?(@tag)
                         })
  end

  def authorize_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied.'
    end
  end

  def set_data_post
    if params[:query].present?
      Post.where(published: true, status: 2).tagged_with(@tag.name).ransack(title_or_description_cont: params[:query]).result(distinct: true)
    else
      Post.where(published: true, status: 2).tagged_with(@tag.name)
    end
  end

  def set_data_video
    if params[:query].present?
      Video.where(published: true, status: 2).tagged_with(@tag.name).ransack(title_or_description_cont: params[:query]).result(distinct: true)
    else
      Video.where(published: true, status: 2).tagged_with(@tag.name)
    end
  end
end