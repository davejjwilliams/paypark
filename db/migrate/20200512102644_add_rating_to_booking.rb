class AddRatingToBooking < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :rating, :integer, null: false, default: 0
  end
end
