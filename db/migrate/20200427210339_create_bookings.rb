class CreateBookings < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.integer :driver_id, foreign_key: true
      t.integer :homeowner_id, foreign_key: true
      t.decimal :price
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :complete, default: false
      t.boolean :withdrawn, default: false

      t.timestamps
    end
  end
end
