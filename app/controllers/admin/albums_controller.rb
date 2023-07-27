class Admin::AlbumsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_album, only: %i[ destroy edit update]
  before_action :authorize_admin

  def index
    @albums = Album.page(params[:page]).per(18)
  end

  def edit
  end

  def update
    # render :json => params
    if params[:photos_delete].present?
      @album.images.where(:id => params[:photos_delete]).each do |img|
        img.purge
      end
    end
    if params[:album][:images].present?
      @album.images.attach(params[:album][:images])
    end
    if @album.update(album_params)
      redirect_to albums_path, notice: "Album was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @album.destroy

    respond_to do |format|
      format.html { redirect_to admin_albums_path, notice: "Album was successfully destroyed." }
    end
  end
  private

  def set_album
    @album = Album.find(params[:id])
  end

  def authorize_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied.'
    end
  end

  def album_params
    params.require(:album).permit(:title, :description, :is_public)
  end
end

