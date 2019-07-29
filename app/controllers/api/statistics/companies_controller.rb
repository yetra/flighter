module Api
  module Statistics
    class CompaniesController < ApplicationController
      before_action :require_login
      before_action :require_permission

      def index
        render json: Company.all,
               each_serializer: Statistics::CompanySerializer,
               status: :ok
      end
    end
  end
end
