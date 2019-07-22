class Session < ActiveModelSerializers::Model
  attributes :user, :token
end
