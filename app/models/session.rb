class Session < ActiveModelSerializers::Model
  attributes :user, token: user.token
end
