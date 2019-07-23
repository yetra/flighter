class SessionSerializer < ActiveModel::Serializer
  belongs_to :user

  attribute :token
end
