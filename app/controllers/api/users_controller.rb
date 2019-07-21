module Api
  class UsersController < ApplicationController
    # GET /api/users(.:format)
    def index
      render json: User.all, status: :ok
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
      user = User.update(params[:id], user_params)

      if user.valid?
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
        :first_name, :last_name, :email, :password, :created_at, :updated_at
      )
    end
  end
end
