class SearchController < ApplicationController

  def search_all
    @users = User.where('first_name LIKE ? OR last_name LIKE ?', "%#{params[:term]}%", "%#{params[:term]}%").limit(3)
    @photos = Photo.where('title LIKE ? AND is_public LIKE ?', "%#{params[:term]}%", true).limit(3)
    @albums = Album.where('title LIKE ? AND is_public LIKE ?', "%#{params[:term]}%", true).limit(3)
    # puts(search_params)
    # puts(@photos)
    # render :json => params
  end

  def show_all_user_search
    @users = User.where('first_name LIKE ? OR last_name LIKE ?', "%#{params[:term]}%", "%#{params[:term]}%").page(params[:page]).per(12)
  end
  def show_all_photo_search
    @photos = Photo.where('title LIKE ? AND is_public LIKE ?', "%#{params[:term]}%", true).page(params[:page]).per(12)
  end

  def show_all_album_search
    @albums = Album.where('title LIKE ? AND is_public LIKE ?', "%#{params[:term]}%", true).page(params[:page]).per(12)
  end
  private
    def search_params
      params.permit(:term)
    end
end
