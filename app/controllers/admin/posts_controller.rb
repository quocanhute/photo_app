class Admin::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin

  def index
    @posts = Post.where(status: :in_queue).order(created_at: :desc).page(params[:page]).per(15)
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
      @post.update_columns(status: 2)
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
      redirect_to root_path, alert: 'Access denied.'
    end
  end
end
