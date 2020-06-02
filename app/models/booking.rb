class Booking < ApplicationRecord
  belongs_to :driver
  belongs_to :homeowner

  validates :start_time, :end_time, presence: true
  validates :price, numericality: { greater_than: 0 }


end
