json.extract! homeowner, :id, :user_id, :address, :latitude, :longitude, :driveway_description, :driveway_price, :driveway_active, :last_modified, :activation_code, :driveway_verified, :total_ratings, :number_ratings, :created_at, :updated_at
json.url homeowner_url(homeowner, format: :json)
