class PhotosController < ApplicationController
  before_action :authenticate_user!, only: %i[ index new edit create update destroy ]
  before_action :set_photo, only: %i[ show edit update destroy ]
  before_action :check_photo_ownership, only: [:edit, :update, :destroy]

  # GET /photos or /photos.json
  def index
    @photos = current_user.photos.page(params[:page]).per(8)
  end

  # GET /photos/1 or /photos/1.json
  def show
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit

  end

  # POST /photos or /photos.json
  def create
    # @photo = Photo.new(photo_params)

    @photo = current_user.photos.new(photo_params)

    respond_to do |format|
      if @photo.save
        format.html { redirect_to photos_url, notice: "Photo was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photos/1 or /photos/1.json
  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to photo_url(@photo), notice: "Photo was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1 or /photos/1.json
  def destroy
    @photo.img.purge
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to photos_url, notice: "Photo was successfully destroyed." }
    end
  end

  # def like_photo
  #   @like = Like.new(photo: @photo,user: current_user)
  #   @like.save
  # end


  private
    # Use callbacks to share common setup or constraints between actions.
  def set_photo
    @photo = Photo.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def photo_params
    params.require(:photo).permit(:title, :url, :img, :description, :is_public)
  end

  # def set_user
  #   @user = User.find(params[:userid])
  # end
  def check_photo_ownership
    photo = Photo.find_by(id: params[:id])
    if photo && photo.user_id == current_user.id
    else
      redirect_to root_path, alert: 'Access denied.'
    end
  end

  def authorize_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied.'
    end
  end
end
