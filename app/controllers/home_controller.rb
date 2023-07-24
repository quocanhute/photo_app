class HomeController < ApplicationController
  def index
    @users = User.all
  end

  def index_show_photo
    @photos = Photo.where(is_public: true ).page(params[:page]).per(6)
  end

  def index_show_album
    @albums = Album.where(is_public: true ).page(params[:page]).per(6)
  end


  private

end