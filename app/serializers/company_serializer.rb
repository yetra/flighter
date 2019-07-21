class CompanySerializer < ActiveModel::Serializer
  has_many :flights

  attribute :id
  attribute :name

  attribute :created_at
  attribute :updated_at
end
