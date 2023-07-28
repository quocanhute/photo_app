class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin

  def index
    @users = User.page(params[:page]).per(15)
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
        format.html { redirect_to view_profile_path(@user), :notice => 'User was successfully created.' }
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
          format.html { redirect_to view_profile_path(@user), :notice => 'User was successfully updated.' }
        else
          format.html { redirect_to edit_admin_user_path(@user), :alert => @user.errors.full_messages.join(', ') }
        end
      end

    else
      respond_to do |format|
        if @user.update(user_params_with_password)
          format.html { redirect_to view_profile_path(@user), :notice => 'User was successfully updated.' }
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
      format.html { redirect_to admin_users_url }
      format.json { head :ok }
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
