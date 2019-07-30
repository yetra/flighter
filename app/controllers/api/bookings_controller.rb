module Api
  class BookingsController < ApplicationController
    before_action :require_login
    before_action :require_permission, only: [:show, :update, :destroy]

    # GET /api/bookings(.:format)
    def index
      bookings = current_user.admin? ? Booking.all : Booking.where(user: current_user)
      bookings = bookings.active if params[:filter] == 'active'

      render json: bookings.includes(:flight, :user)
                           .order('flights.flys_at, flights.name, bookings.created_at'),
             status: :ok
    end

    # POST /api/bookings(.:format)
    def create
      booking = Booking.new(booking_params.reverse_merge(user_id: current_user.id))

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
      booking = Booking.update(params[:id], booking_params.except(:flight_id))

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
      if current_user.admin?
        params.require(:booking)
              .permit(:user_id, :flight_id, :no_of_seats, :created_at, :updated_at)
      else
        params.require(:booking)
              .permit(:flight_id, :no_of_seats, :created_at, :updated_at)
      end
    end

    def permitted?
      Booking.find(params[:id]).user_id == current_user.id || super
    end
  end
end
