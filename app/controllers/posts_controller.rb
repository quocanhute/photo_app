class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[ index new edit create update destroy ]
  before_action :set_post, only: %i[ show edit update destroy publish unpublish]

  # GET /posts or /posts.json
  def index
    @posts = current_user.posts
  end

  # GET /posts/1 or /posts/1.json
  def show
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
        format.html { redirect_to edit_post_path(@post), notice: "Post was successfully updated." }
      else
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

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = current_user.posts.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :description, :header_image)
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

end
