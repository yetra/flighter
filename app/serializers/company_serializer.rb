class CompanySerializer < ActiveModel::Serializer
  has_many :flights

  attribute :id
  attribute :name

  attribute :no_of_active_flights

  attribute :created_at
  attribute :updated_at

  def no_of_active_flights
    object.flights.where('flys_at > CURRENT_TIMESTAMP').count
  end
end
