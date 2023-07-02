class ProfileController < ApplicationController
  include ProfileHelper
  before_action :authenticate_user!
  before_action :set_user
  def show

  end

  def follow
    Relationship.create_or_find_by(follower_id: current_user.id, followee_id: @user.id)
    redirect_back(fallback_location: root_path)
  end


  def unfollow
    current_user.followed_user.where(follower_id: current_user.id, followee_id: @user.id).destroy_all
    redirect_back(fallback_location: root_path)
  end


  private

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation, :current_password)
    end
    def set_user
      @user = User.find(params[:id])
    end
end
