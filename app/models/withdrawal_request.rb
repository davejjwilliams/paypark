class WithdrawalRequest < ApplicationRecord
  belongs_to :homeowner

  validates :request_date, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }
end
