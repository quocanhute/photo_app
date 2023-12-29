class ErrorsController < ApplicationController

  def not_found_404
    render status: 404
  end

  def not_authen_403
    render status: 403
  end

  def internal_server_error_500
    render status: 500
  end
end
