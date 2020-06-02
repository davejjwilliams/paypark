class Driver < ApplicationRecord
  belongs_to :user

  has_many :bookings, dependent: :destroy
  validates :registration_number, :car_info, presence: true
end
