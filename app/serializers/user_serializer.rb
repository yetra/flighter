class UserSerializer < ActiveModel::Serializer
  has_many :bookings

  attribute :id
  attribute :first_name
  attribute :last_name

  attribute :email

  attribute :created_at
  attribute :updated_at
end
