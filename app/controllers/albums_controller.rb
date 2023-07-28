class AlbumsController < ApplicationController
  before_action :authenticate_user!, only: %i[ index new edit create update destroy ]
  before_action :set_album, only: %i[ show edit update destroy delete_image_attachment ]
  before_action :check_album_ownership, only: [:edit, :update, :destroy]
  # GET /albums or /albums.json
  def index
    @albums = current_user.albums.page(params[:page]).per(8)
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
    if params[:album][:images].present?
      @album.images.attach(params[:album][:images])
    end
    if @album.save
      redirect_to albums_path, notice: "Album was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /albums/1 or /albums/1.json
  def update
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

  # DELETE /albums/1 or /albums/1.json
  def destroy
    @album.destroy

    respond_to do |format|
      format.html { redirect_to albums_url, notice: "Album was successfully destroyed." }
    end
  end

  def delete_image_attachment
    img = @album.images.find(params[:id_key])
    img.purge
    redirect_to albums_url
  end

  def like_album
    @album = Album.find(params[:id])
    current_user.like_album(@album)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: private_stream_album
      end
    end
  end

  private
  def set_album
    @album = Album.find(params[:id])
  end

  def album_params
    params.require(:album).permit(:title, :description, :is_public)
  end

  def get_images_update_album
    params.require(:album).permit(images: [])
  end

  def check_album_ownership
    album = Album.find_by(id: params[:id])
    if album && album.user_id == current_user.id
    else
      redirect_to root_path, alert: 'Access denied.'
    end
  end

  def private_stream_album
    private_target = "#{helpers.dom_id(@album)} album_private_likes"
    turbo_stream.replace(private_target,
                         partial: 'likes/private_button_album',
                         locals:{
                           album: @album,
                           album_like_status: current_user.liked_album?(@album)
                         })
  end
end
