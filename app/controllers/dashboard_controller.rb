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

  private

end
