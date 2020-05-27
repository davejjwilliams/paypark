class Homeowner < ApplicationRecord
  belongs_to :user

  has_many :bookings, dependent: :destroy

  validates :address, :paypal_email, :driveway_description, :driveway_price, presence: true
end
