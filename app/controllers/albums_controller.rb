class AlbumsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_album, only: %i[ show edit update destroy delete_image_attachment ]

  # GET /albums or /albums.json
  def index
    @albums = current_user.albums.all
  end

  # GET /albums/1 or /albums/1.json
  def show
  end

  # GET /albums/new
  def new
    @album = Album.new
  end

  # GET /albums/1/edit
  def edit
  end

  # POST /albums or /albums.json
  def create
    @album = current_user.albums.new(album_params)
    if @album.save
      redirect_to album_url(@album), notice: "Album was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /albums/1 or /albums/1.json
  def update
    # render :json => params
    respond_to do |format|
      if params[:photos_delete].present?
        @album.images.where(:id => params[:photos_delete]).each do |img|
          img.destroy
        end
      end
      if @album.update(album_params)
        format.html { redirect_to album_url(@album), notice: "Album was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1 or /albums/1.json
  def destroy
    @album.destroy

    respond_to do |format|
      format.html { redirect_to albums_url, notice: "Album was successfully destroyed." }
    end
  end

  def delete_image_attachment
    img = @album.images.find(params[:idKey])
    img.purge
    redirect_to albums_url
  end

  private
  def set_album
    @album = Album.find(params[:id])
  end

  def album_params
    params.require(:album).permit(:title, :description, :is_public,images: [])
  end

  def get_images_update_album
    params.require(:album).permit(images: [])
  end
end
