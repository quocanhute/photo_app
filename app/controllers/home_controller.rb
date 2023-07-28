class HomeController < ApplicationController
  def index
  end

  def index_show_photo
    # @photos = Photo.where(is_public: true ).page(params[:page]).per(6)
    # @pagy, @photos = pagy(Photo.all, items:6)
    @pagy, @photos = pagy_countless(Photo.all, items:6)
    # sleep(1)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def index_show_album
    # @albums = Album.where(is_public: true ).page(params[:page]).per(6)
    @pagy, @albums = pagy_countless(Album.all, items:6)
    # sleep(1)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end


  private

end