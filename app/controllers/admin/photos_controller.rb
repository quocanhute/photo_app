class Admin::PhotosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_photo, only: %i[ destroy ]
  before_action :authorize_admin

  def index
    @photos = Photo.page(params[:page]).per(8)
  end


  def destroy
    @photo.img.purge
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to admin_photos_path, notice: "Photo was successfully destroyed." }
    end
  end
  private

  def set_photo
    @photo = Photo.find(params[:id])
  end

  def authorize_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied.'
    end
  end
end
