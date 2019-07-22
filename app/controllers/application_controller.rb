class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def require_login
    authenticate_token || render_unauthenticated
  end

  def require_permission
    permitted? || render_forbidden
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

  def render_forbidden
    head :forbidden
  end

  def permitted?
    current_user.admin?
  end

  private

  def authenticate_token
    token = request.headers['Authorization']

    User.find_by(token: token)
  end
end
