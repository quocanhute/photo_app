class HomeController < ApplicationController
  before_action :get_all_photos, :get_all_albums, :set_user_gid
  def index
  end

  def like_photo
    @photo = Photo.find(params[:id])
    current_user.like(@photo)
    # redirect_to root_url
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: private_stream
      end
    end
  end

  private

  def private_stream
    private_target = "#{helpers.dom_id(@photo)} private_likes"
    turbo_stream.replace(private_target,
                         partial: 'likes/private_button',
                         locals:{
                           photo: @photo,
                           like_status: current_user.liked?(@photo)
                         })
  end
  def get_all_photos
    @photos = Photo.all
  end
  def get_all_albums
    @albums = Album.all
  end
  def set_user_gid
    @user_gid = current_user.to_gid_param if current_user
  end
end