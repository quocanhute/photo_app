class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[ index new edit create update destroy vote bookmark]
  before_action :set_post, only: %i[ show edit update destroy publish unpublish vote bookmark]
  before_action :check_post_ownership, only: [:edit, :update, :destroy]

  # GET /posts or /posts.json
  def index
    @posts = current_user.posts
  end

  # GET /posts/1 or /posts/1.json
  def show
    if current_user
      @post.increment!(:total_views)
    end
  end

  # GET /posts/new
  def new
    @post = current_user.posts.build
  end

  # GET /posts/1/edit
  def edit
    @element = @post.elements.build
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to edit_post_path(@post), notice: "Post was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html {
          flash[:notice] = 'Post was successfully updated.'
          redirect_to edit_post_path(@post)
        }
      else
        @element = @post.elements.build
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def publish
    @post.update(published: true, published_at: Time.now)
    unless @post.already_published
      @post.update(already_published: true)
      @post.user.follower.each do |user|
        message = "User #{@post.user.username} just creating a new posts"
        create_notification_for_follower(@post,@post.user,user,message)
      end
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [update_action_publish,update_published_at]
      end
    end
  end

  def unpublish
    @post.update(published: false, published_at: nil)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [update_action_publish,update_published_at]
      end
    end
  end

  def bookmark
      @post.bookmark!(current_user)
      respond_to do |format|
        format.html do
          redirect_to @post
        end
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@post, partial: "posts/post", locals: {post: @post})
        end
      end
  end

  def vote
    case params[:type]
    when 'upvote'
      @post.upvote!(current_user)
    when 'downvote'
      @post.downvote!(current_user)
    else
      return redirect_to request.url, alert: "No such vote type"
    end
    respond_to do |format|
      format.html do
        redirect_to @post
      end
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@post, partial: "posts/post", locals: {post: @post})
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :description, :header_image, :tag_list)
  end

  def update_action_publish
    private_target = ".#{helpers.dom_id(@post)}_publish_post"
    turbo_stream.replace_all(private_target,
                             partial: 'posts/publisher_button',
                             locals: {
                               post: @post
                             })
  end

  def update_published_at
    private_target = ".#{helpers.dom_id(@post)}_published_at"
    turbo_stream.replace_all(private_target,
                             partial: 'posts/published_at',
                             locals: {
                               post: @post
                             })
  end

  def create_notification_for_follower(post,followee,follower,message)
    # Tạo Notification cho comment
    Notification.create(
      sender: followee,
      receiver: follower,
      object: post,
      as_read: false,
      content: message
    )
  end

  def check_post_ownership
    post = Post.find_by(id: params[:id])
    if post && post.user_id == current_user.id
    else
      redirect_to root_path, alert: 'Access denied.'
    end
  end

end
