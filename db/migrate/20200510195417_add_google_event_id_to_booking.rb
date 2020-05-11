class AddGoogleEventIdToBooking < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :calendar_event_id, :string, null: false, default: ""
  end
end
