json.extract! withdrawal_request, :id, :homeowner_id, :amount, :request_date, :created_at, :updated_at
json.url withdrawal_request_url(withdrawal_request, format: :json)
