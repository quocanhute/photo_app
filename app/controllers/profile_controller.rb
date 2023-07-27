class ProfileController < ApplicationController
  include ProfileHelper
  before_action :authenticate_user!, only: %i[ follow unfollow]
  before_action :set_user
  def show
    if current_user
      if params[:id].to_f == current_user.id
        @photos = current_user.photos.page(params[:page]).per(8)
      else
        @photos = @user.photos.where(is_public: true ).page(params[:page]).per(8)
      end
    else
      @photos = @user.photos.where(is_public: true ).page(params[:page]).per(8)
    end
  end

  def show_photo
    if current_user
      if params[:id].to_f == current_user.id
        @photos = current_user.photos.page(params[:page]).per(8)
      else
        @photos = @user.photos.where(is_public: true ).page(params[:page]).per(8)
      end
    else
      @photos = @user.photos.where(is_public: true ).page(params[:page]).per(8)
    end

  end

  def show_album
    if current_user
      if params[:id].to_f == current_user.id
        @albums = current_user.albums.page(params[:page]).per(8)
      else
        @albums = @user.albums.where(is_public: true ).page(params[:page]).per(8)
      end
    else
      @albums = @user.albums.where(is_public: true ).page(params[:page]).per(8)
    end
  end

  def show_follower_user
    @follower = @user.follower
  end

  def show_followee_user
    @followee = @user.followee
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
    # puts(current_user.id)
    # puts(@user.id)
    # puts(current_user.followed_user.where(follower_id: current_user.id, followee_id: @user.id))
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
    private_target = ".#{dom_id_for_follower(@user)}_follow_user"
    turbo_stream.replace_all(private_target,
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
