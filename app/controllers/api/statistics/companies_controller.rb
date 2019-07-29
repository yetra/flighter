module Api
  module Statistics
    class CompaniesController < ApplicationController
      def index
        render json: Company.all,
               each_serializer: Statistics::CompanySerializer,
               status: :ok
      end
    end
  end
end
