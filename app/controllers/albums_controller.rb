class AlbumsController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_user
  before_action :set_album, only: %i[ show edit update destroy ]

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
    respond_to do |format|
      if @album.update(album_params)
        if params[:album][:images].present?
          params[:album][:images].each do |image|
            @album.images.attach(image)
          end
        end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def album_params
      params.fetch(:album, {})
      params.require(:album).permit(:title, :description, :is_public,images: [])
    end

    # def set_user
    #   @user = User.find(params[:userid])
    # end
end
