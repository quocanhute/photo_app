class SearchController < ApplicationController
  def index
    # @results = search_for_photos
  end

  def suggestions
    @results = search_for_photos

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
                 turbo_stream.update('suggestions',
                                     partial: 'search/suggestions',
                                     locals: { results: @results })
      end
    end
  end
  def search_all
    @users = User.where('first_name LIKE ? OR last_name LIKE ?', "%#{params[:query]}%", "%#{params[:query]}%").limit(3)
    @photos = Photo.where('title LIKE ? AND is_public LIKE ?', "%#{params[:query]}%", true).limit(3)
    @albums = Album.where('title LIKE ? AND is_public LIKE ?', "%#{params[:query]}%", true).limit(3)
    # puts(search_params)
    # puts(@photos)
    # render :json => params
  end

  def show_all_user_search
    @users = User.where('first_name LIKE ? OR last_name LIKE ?', "%#{params[:query]}%", "%#{params[:query]}%").page(params[:page]).per(12)
  end
  def show_all_photo_search
    @photos = Photo.where('title LIKE ? AND is_public LIKE ?', "%#{params[:query]}%", true).page(params[:page]).per(12)
  end

  def show_all_album_search
    @albums = Album.where('title LIKE ? AND is_public LIKE ?', "%#{params[:query]}%", true).page(params[:page]).per(12)
  end
  private
  def search_params
    params.permit(:term)
  end
  def search_for_photos
    if params[:query].blank?
      Photo.all.limit(5)
    else
      Photo.where('title LIKE ?', "%#{params[:query]}%").limit(5)
    end
  end
end
