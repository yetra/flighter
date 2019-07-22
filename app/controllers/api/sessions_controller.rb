module Api
  class SessionsController < ApplicationController
    before_action :require_login, except: [:create]

    def create
      user = User.find_by(email: session_params[:email])

      if user&.authenticate(session_params[:password])
        session = Session.new(user)

        render json: session, status: :created
      else
        render_unauthorized
      end
    end

    def destroy
      current_user.regenerate_token

      head :no_content
    end

    def session_params
      params.require(:session).permit(:email, :password)
    end
  end
end
