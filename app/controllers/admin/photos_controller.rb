class Admin::PhotosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_photo, only: %i[ destroy edit update ]
  before_action :authorize_admin

  def index
    # @photos = Photo.page(params[:page]).per(18)
    @pagy, @photos = pagy_countless(Photo.all, items:18)
    # sleep(1)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def edit

  end

  def update
    # @photo.img.purge
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to admin_photos_path, notice: "Photo was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @photo.img.purge
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to admin_photos_path, notice: "Photo was successfully destroyed." }
    end
  end
  private

  def photo_params
    params.require(:photo).permit(:title, :url, :img, :description, :is_public)
  end

  def set_photo
    @photo = Photo.find(params[:id])
  end

  def authorize_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied.'
    end
  end
end
