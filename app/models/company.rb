class Company < ActiveRecord
  has_many :flights, dependent: :destroy
end
