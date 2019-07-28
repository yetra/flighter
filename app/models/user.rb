# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  first_name      :string
#  last_name       :string
#  email           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string
#  token           :string
#  role            :string
#

class User < ApplicationRecord
  has_secure_password
  has_secure_token

  has_many :bookings, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  validates :first_name, presence: true, length: { minimum: 2 }

  validates :role, inclusion: %w[admin], allow_nil: true

  scope :contains_query, lambda { |query|
    where('email ILIKE :q OR first_name ILIKE :q OR last_name ILIKE :q', q: "%#{query}%")
  }

  def admin?
    role == 'admin'
  end
end
