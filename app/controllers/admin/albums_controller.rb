class Admin::AlbumsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_photo, only: %i[ destroy ]
  before_action :authorize_admin

  def index
    @albums = Album.page(params[:page]).per(18)
  end


  def destroy
    @album.destroy

    respond_to do |format|
      format.html { redirect_to admin_albums_path, notice: "Album was successfully destroyed." }
    end
  end
  private

  def set_photo
    @album = Album.find(params[:id])
  end

  def authorize_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied.'
    end
  end
end

