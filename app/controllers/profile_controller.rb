class ProfileController < ApplicationController
  include ProfileHelper
  before_action :authenticate_user!
  before_action :set_user
  def show
    @photos = @user.photos
  end

  def show_photo

  end

  def show_album

  end

  def follow
    Relationship.create_or_find_by(follower_id: current_user.id, followee_id: @user.id)
    # redirect_back(fallback_location: root_path)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [update_action_follow,update_count_follower]
      end
    end
  end


  def unfollow
    current_user.followed_user.where(follower_id: current_user.id, followee_id: @user.id).destroy_all
    # redirect_back(fallback_location: root_path)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [update_action_follow,update_count_follower]
      end
    end
  end


  private
  def update_action_follow
    private_target = "#{dom_id_for_follower(@user)} follow_user"
    turbo_stream.replace(private_target,
                         partial: 'profile/follow_button',
                         locals: {
                           user: @user
                         })
  end

  def update_count_follower
    private_target = "#{@user.id}-follower-count"
    turbo_stream.update(private_target,
                        partial: 'profile/follower_count',
                        locals: { user: @user
                        })
  end
  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation, :current_password)
  end
  def set_user
    @user = User.find(params[:id])
  end
end
