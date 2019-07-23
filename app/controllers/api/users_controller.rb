module Api
  class UsersController < ApplicationController
    before_action :require_login, except: [:create]
    before_action :require_permission, only: [:show, :update, :destroy]

    # GET /api/users(.:format)
    def index
      if current_user.admin?
        render json: User.all, status: :ok
      else
        render_forbidden
      end
    end

    # POST /api/users(.:format)
    def create
      user = User.new(user_params)

      if user.save
        render json: user, status: :created
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    # GET /api/users/:id(.:format)
    def show
      user = User.find(params[:id])

      if user
        render json: user, status: :ok
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    # PUT /api/users/:id(.:format)
    def update
      user = User.find(params[:id])
      user.attributes = user_params

      if user.role_changed? && !current_user.admin?
        render_forbidden
      elsif user.save
        render json: user, status: :ok
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    # DELETE /api/users/:id(.:format)
    def destroy
      user = User.find(params[:id])

      if user.destroy
        head :no_content
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    private

    def user_params
      params.require(:user).permit(
        :first_name, :last_name, :email, :password, :role, :created_at, :updated_at
      )
    end

    def permitted?
      params[:id].to_i == current_user.id || super
    end
  end
end
