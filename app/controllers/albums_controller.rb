class AlbumsController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_user
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
    if params[:album][:images].present?
      @album = current_user.albums.new(album_params_with_images)
    else
      @album = current_user.albums.new(album_params_without_images)
    end
    respond_to do |format|
      if @album.save
        format.html { redirect_to album_url(@album), notice: "Album was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
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
      if params[:album][:images].present?
        if @album.update(album_params_with_images)
          format.html { redirect_to album_url(@album), notice: "Album was successfully updated." }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      else
        if @album.update(album_params_without_images)
          format.html { redirect_to album_url(@album), notice: "Album was successfully updated." }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /albums/1 or /albums/1.json
  def destroy
    @album.images.each  do |img|
      img.purge
    end
    @album.destroy

    respond_to do |format|
      format.html { redirect_to albums_url, notice: "Album was successfully destroyed." }
    end
  end

  def delete_image_attachment
    # @image = ActiveStorage::Attachment.find(params[:idKey])
    # @image.purge
    img = @album.images.find(params[:idKey])
    img.purge
    redirect_to albums_url
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_album
    @album = Album.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def album_params_without_images
    # params.fetch(:album, {})
    params.require(:album).permit(:title, :description, :is_public)
  end

  def album_params_with_images
    # params.fetch(:album, {})
    params.require(:album).permit(:title, :description, :is_public,images: [])
  end

  def get_images_update_album
    params.require(:album).permit(images: [])
  end
    # def set_user
    #   @user = User.find(params[:userid])
    # end
end
