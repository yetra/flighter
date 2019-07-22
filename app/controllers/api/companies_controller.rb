module Api
  class CompaniesController < ApplicationController
    before_action :require_login, only: [:create, :update, :destroy]
    before_action :require_permission, only: [:create, :update, :destroy]

    # GET /api/companies(.:format)
    def index
      render json: Company.all, status: :ok
    end

    # POST /api/companies(.:format)
    def create
      company = Company.new(company_params)

      if company.save
        render json: company, status: :created
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    # GET /api/companies/:id(.:format)
    def show
      company = Company.find(params[:id])

      if company
        render json: company, status: :ok
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    # PUT /api/companies/:id(.:format)
    def update
      company = Company.update(params[:id], company_params)

      if company.valid?
        render json: company, status: :ok
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    # DELETE /api/companies/:id(.:format)
    def destroy
      company = Company.find(params[:id])

      if company.destroy
        head :no_content
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    private

    def company_params
      params.require(:company).permit(:name, :created_at, :updated_at)
    end
  end
end
