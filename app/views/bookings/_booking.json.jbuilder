json.extract! booking, :id, :driver_id, :homeowner_id, :price, :start_time, :end_time, :complete, :withdrawn, :created_at, :updated_at
json.url booking_url(booking, format: :json)
