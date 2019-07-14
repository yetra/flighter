class Company < ApplicationRecord
  has_many :flights, dependent: :destroy
end
