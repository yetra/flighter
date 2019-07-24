module Api
  class BookingsController < ApplicationController
    before_action :require_login
    before_action :require_permission, only: [:show, :update, :destroy]

    # GET /api/bookings(.:format)
    def index
      if current_user.admin?
        render json: Booking.all, status: :ok
      else
        render json: Booking.where(user: current_user), status: :ok
      end
    end

    # POST /api/bookings(.:format)
    def create
      booking = Booking.new(booking_params)

      if booking.save
        render json: booking, status: :created
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    # GET /api/bookings/:id(.:format)
    def show
      booking = Booking.find(params[:id])

      if booking
        render json: booking, status: :ok
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    # PUT /api/bookings/:id(.:format)
    def update
      booking = Booking.find(params[:id])
      booking.attributes = booking_params

      if booking.user_id_changed? && !current_user.admin?
        render_forbidden
      elsif booking.save
        render json: booking, status: :ok
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    # DELETE /api/bookings/:id(.:format)
    def destroy
      booking = Booking.find(params[:id])

      if booking.destroy
        head :no_content
      else
        render json: { errors: booking.errors }, status: :bad_request
      end
    end

    private

    def booking_params
      permitted_params = [:flight_id, :seat_price, :no_of_seats, :created_at, :updated_at]
      permitted_params.push(:user_id) if current_user.admin?

      params.require(:booking).permit(permitted_params)
    end

    def permitted?
      Booking.find(params[:id]).user_id == current_user.id || super
    end
  end
end
