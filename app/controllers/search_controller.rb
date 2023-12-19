class SearchController < ApplicationController
  before_action :set_data
  def suggestions
    @users = search_for_users

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
                 turbo_stream.update('suggestions',
                                     partial: 'search/suggestions',
                                     locals: {
                                       users: @users
                                     })
      end
    end
  end
  def search_all
    if params[:query].blank?
      @users =  @search_blank_users
    else
      @users = @set_users.limit(6)
    end

  end

  def show_all_user_search
    if params[:query].blank?
      @users =  User.page(params[:page]).per(12)
    else
      @users = @set_users.page(params[:page]).per(12)
    end
  end

  private
  def set_data
    # @set_users = User.where('first_name LIKE ? OR last_name = ?', "%#{params[:query]}%", "%#{params[:query]}%")
    puts "Paramseeeee: #{params[:query]}"
    @q_user = User.ransack(first_name_or_last_name_cont: params[:query])
    @set_users = @q_user.result(distinct: true)
    @search_blank_users = User.limit(6)
  end
  def search_params
    params.permit(:term)
  end
  def search_for_users
    if params[:query].blank?
      User.limit(2)
    else
      @set_users
    end
  end
end
