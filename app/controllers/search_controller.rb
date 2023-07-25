class SearchController < ApplicationController

  def search_all
    @users = User.where('first_name LIKE ? OR last_name LIKE ?', "%#{params[:term]}%", "%#{params[:term]}%").limit(3)
    @photos = Photo.where('title LIKE ? AND is_public LIKE ?', "%#{params[:term]}%", true).limit(3)
    @albums = Album.where('title LIKE ? AND is_public LIKE ?', "%#{params[:term]}%", true).limit(3)
    # puts(search_params)
    # puts(@photos)
    # render :json => params
  end

  private
    def search_params
      params.permit(:term)
    end
end
