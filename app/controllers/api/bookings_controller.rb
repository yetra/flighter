module Api
  class BookingsController < ApplicationController
    before_action :require_login

    # GET /api/bookings(.:format)
    def index
      render json: Booking.all, status: :ok
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
      booking = Booking.update(params[:id], booking_params)

      if booking.valid?
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
      params.require(:booking).permit(
        :user_id, :flight_id, :seat_price, :no_of_seats, :created_at, :updated_at
      )
    end
  end
end
