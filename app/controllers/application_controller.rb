class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def require_login
    authenticate_token || render_unauthenticated
  end

  def current_user
    @current_user ||= authenticate_token
  end

  protected

  def render_unauthorized
    errors = { errors: { credentials: ['are invalid'] } }

    render json: errors, status: :bad_request
  end

  def render_unauthenticated
    errors = { errors: { token: ['is invalid'] } }

    render json: errors, status: :unauthorized
  end

  private

  def authenticate_token
    authenticate_with_http_token do |token, _|
      User.find_by(token: token)
    end
  end
end
