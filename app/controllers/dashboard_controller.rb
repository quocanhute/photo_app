class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @follower = current_user.follower
  end

  def following_users
    @followee = current_user.followee
  end

  def following_tags
    @tags = current_user.tags
  end

  def posts_bookmark
    @posts = Post.bookmarked_by_user(current_user)
  end

  def videos_bookmark
    @videos = Video.bookmarked_by_user(current_user)
  end

  private

end
