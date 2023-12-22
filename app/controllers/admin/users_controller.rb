class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin

  def index
    @users = User.where(is_ban: false ).order(last_name: :asc,first_name: :asc).page(params[:page]).per(15)
  end

  def index_ban_user
    @users = User.where(is_ban: true ).order(last_name: :asc,first_name: :asc).page(params[:page]).per(15)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params_with_password)

    respond_to do |format|
      if @user.save
        format.html { redirect_to profile_path(@user), :notice => 'User was successfully created.' }
      else
        format.html { redirect_to new_admin_user_path, :alert => @user.errors.full_messages.join(', ') }
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if params[:user][:password].blank?
      respond_to do |format|
        if @user.update(user_params_without_password)
          format.html { redirect_to profile_path(@user), :notice => 'User was successfully updated.' }
        else
          format.html { redirect_to edit_admin_user_path(@user), :alert => @user.errors.full_messages.join(', ') }
        end
      end

    else
      respond_to do |format|
        if @user.update(user_params_with_password)
          format.html { redirect_to profile_path(@user), :notice => 'User was successfully updated.' }
        else
          format.html { redirect_to edit_admin_user_path(@user), :alert => @user.errors.full_messages.join(', ') }
        end
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to admin_users_url, :notice => 'User was successfully destroyed.'  }
    end
  end

  def action_ban_user
    @user = User.find(params[:id])
  end

  def action_unban_user
    @user = User.find(params[:id])
  end

  def ban_user
    ActiveRecord::Base.transaction do
      @user = User.find(params[:id])
      @user.update_columns(is_ban: true)
      UserMailer.ban_user_email(@user).deliver_later
    end
    respond_to do |format|
      format.html { redirect_to admin_users_url, :notice => 'User was successfully banned.'  }
    end
  end

  def unban_user
    ActiveRecord::Base.transaction do
      @user = User.find(params[:id])
      @user.update_columns(is_ban: false)
      UserMailer.unban_user_email(@user).deliver_later
    end

    respond_to do |format|
      format.html { redirect_to admin_index_ban_user_url, :notice => 'User was successfully unbanned.'  }
    end
  end

  private

  def user_params_with_password
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation, :role)
  end
  def user_params_without_password
    params.require(:user).permit(:email, :first_name, :last_name, :role)
  end

  def authorize_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied.'
    end
  end
end
