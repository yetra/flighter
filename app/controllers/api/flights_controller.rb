module Api
  class FlightsController < ApplicationController
    before_action :require_login, only: [:create, :update, :destroy]
    before_action :require_permission, only: [:create, :update, :destroy]

    # GET /api/flights(.:format)
    def index
      render json: Flight.all.order(:flys_at, :name, :created_at), status: :ok
    end

    # POST /api/flights(.:format)
    def create
      flight = Flight.new(flight_params)

      if flight.save
        render json: flight, status: :created
      else
        render json: { errors: flight.errors }, status: :bad_request
      end
    end

    # GET /api/flights/:id(.:format)
    def show
      flight = Flight.find(params[:id])

      if flight
        render json: flight, status: :ok
      else
        render json: { errors: flight.errors }, status: :bad_request
      end
    end

    # PUT /api/flights/:id(.:format)
    def update
      flight = Flight.update(params[:id], flight_params)

      if flight.valid?
        render json: flight, status: :ok
      else
        render json: { errors: flight.errors }, status: :bad_request
      end
    end

    # DELETE /api/flights/:id(.:format)
    def destroy
      flight = Flight.find(params[:id])

      if flight.destroy
        head :no_content
      else
        render json: { errors: flight.errors }, status: :bad_request
      end
    end

    private

    def flight_params
      params.require(:flight).permit(
        :company_id, :name, :no_of_seats, :base_price, :flys_at, :lands_at, :created_at, :updated_at
      )
    end
  end
end
