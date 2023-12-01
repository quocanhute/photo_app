class HomeController < ApplicationController
  def index
  end

  def index_show_photo
    @pagy, @photos = pagy_countless(Photo.where(is_public: true), items:6)
    # sleep(1)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def index_show_album
    @pagy, @albums = pagy_countless(Album.where(is_public: true), items:6)
    # sleep(1)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def index_show_post
    @pagy, @posts = pagy_countless(Post.where(published: true), items:10)
    # sleep(1)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end


  private

end