class Homeowner < ApplicationRecord
  belongs_to :user

  has_many :bookings, dependent: :destroy
  has_many :withdrawal_requests, dependent: :destroy

  validates :address, :paypal_email, :driveway_description, :driveway_price, presence: true
  validates :driveway_price, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
end
