class Admin::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin

  def index
    data_post = set_data_post
    @posts = data_post.where(status: :in_queue).order(created_at: :desc).page(params[:page]).per(10)
  end

  def action_accept_post
    @post = Post.find(params[:id])
  end

  def action_refuse_post
    @post = Post.find(params[:id])
  end

  def accept_post
    ActiveRecord::Base.transaction do
      @post = Post.find(params[:id])
      @post.update_columns(published: true,status: 2)
      Notification.create(
        sender: current_user,
        receiver: @post.user,
        object: @post,
        as_read: false,
        content: "Your post name #{@post.title} successfully accept!"
      )
      @post.user.follower.each do |user|
        message = "User #{@post.user.username} just creating a new posts!"
        Notification.create(
          sender: @post.user,
          receiver: user,
          object: @post,
          as_read: false,
          content: message
        )
      end
    end
    respond_to do |format|
      format.html { redirect_to admin_posts_url, :notice => 'Post was successfully accept.'  }
    end
  end

  def refuse_post
    ActiveRecord::Base.transaction do
      @post = Post.find(params[:id])
      @post.update_columns(status: 3,published: false, published_at: nil)
      Notification.create(
        sender: current_user,
        receiver: @post.user,
        object: @post,
        as_read: false,
        content: "Your post name #{@post.title} was refuse!",
        status: 1
      )
    end

    respond_to do |format|
      format.html { redirect_to admin_posts_url, :notice => 'Post was successfully refuse.'  }
    end
  end

  private

  def authorize_admin
    unless current_user&.admin? || current_user&.censor?
      redirect_to '/403'
    end
  end

  def set_data_post
    if params[:query_admin_post].present?
      Post.ransack(title_or_description_cont: params[:query_admin_post]).result(distinct: true)
    else
      Post
    end
  end
end
