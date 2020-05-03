class AddPaymentIntentAndPaidStatusToBookings < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :payment_intent, :string, default: ""
    add_column :bookings, :paid, :boolean, null: false, default: false
  end
end
