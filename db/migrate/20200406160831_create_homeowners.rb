class CreateHomeowners < ActiveRecord::Migration[5.2]
  def change
    create_table :homeowners do |t|
      t.belongs_to :user, foreign_key: true
      t.text :address
      t.decimal :latitude
      t.decimal :longitude
      t.text :driveway_description
      t.decimal :driveway_price
      t.boolean :driveway_active, default: false
      t.date :last_modified
      t.text :activation_code
      t.boolean :driveway_verified, default: false
      t.integer :total_ratings, default: 0
      t.integer :number_ratings, default: 0

      t.timestamps
    end
  end
end
