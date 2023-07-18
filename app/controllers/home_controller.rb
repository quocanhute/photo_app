class HomeController < ApplicationController
  before_action :set_user_gid
  def index
  end

  def index_show_photo
    @photos = Photo.where(is_public: true ).page(params[:page]).per(6)
  end

  def index_show_album
    @albums = Album.where(is_public: true ).page(params[:page]).per(6)
  end
  def like_photo
    @photo = Photo.find(params[:id])
    current_user.like(@photo)
    # redirect_to root_url
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: private_stream_photo
      end
    end
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

  def private_stream_photo
    private_target = "#{helpers.dom_id(@photo)} private_likes"
    turbo_stream.replace(private_target,
                         partial: 'likes/private_button',
                         locals:{
                           photo: @photo,
                           like_status: current_user.liked?(@photo)
                         })
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
  def set_user_gid
    @user_gid = current_user.to_gid_param if current_user
  end
end