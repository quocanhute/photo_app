class SearchController < ApplicationController
  before_action :set_data
  def suggestions
    @users = search_for_users
    @photos = search_for_photos
    @albums = search_for_albums

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
                 turbo_stream.update('suggestions',
                                     partial: 'search/suggestions',
                                     locals: {
                                       photos: @photos,
                                       albums: @albums,
                                       users: @users
                                     })
      end
    end
  end
  def search_all
    if params[:query].blank?
      @users =  @search_blank_users
      @photos = @search_blank_photos
      @albums = @search_blank_albums
    else
      @users = @set_users.limit(6)
      @photos = @set_photos.limit(6)
      @albums = @set_albums.limit(6)
    end

  end

  def show_all_user_search
    if params[:query].blank?
      @users =  User.page(params[:page]).per(12)
    else
      @users = @set_users.page(params[:page]).per(12)
    end
  end
  def show_all_photo_search
    if params[:query].blank?
      @photos = Photo.where(is_public: true).page(params[:page]).per(12)
    else
      @photos = @set_photos.page(params[:page]).per(12)
    end
  end

  def show_all_album_search
    if params[:query].blank?
      @albums = Album.where(is_public: true).page(params[:page]).per(12)
    else
      @albums = @set_albums.page(params[:page]).per(12)
    end
  end

  private
  def set_data
    # @set_users = User.where('first_name LIKE ? OR last_name = ?', "%#{params[:query]}%", "%#{params[:query]}%")
    puts "Paramseeeee: #{params[:query]}"
    @q_user = User.ransack(first_name_or_last_name_cont: params[:query])
    @set_users = @q_user.result(distinct: true)
    @set_photos = Photo.where('title LIKE ? AND is_public = ?', "%#{params[:query]}%", true)
    @set_albums = Album.where('title LIKE ? AND is_public = ?', "%#{params[:query]}%", true)
    @search_blank_users = User.limit(6)
    @search_blank_photos = Photo.where(is_public: true).limit(6)
    @search_blank_albums = Album.where(is_public: true).limit(6)
  end
  def search_params
    params.permit(:term)
  end
  def search_for_photos
    if params[:query].blank?
      Photo.where(is_public: true).limit(2)
    else
      @set_photos.limit(2)
    end
  end
  def search_for_albums
    if params[:query].blank?
      Album.where(is_public: true).limit(2)
    else
      @set_albums.limit(2)
    end
  end
  def search_for_users
    if params[:query].blank?
      User.limit(2)
    else
      @set_users
    end
  end
end
