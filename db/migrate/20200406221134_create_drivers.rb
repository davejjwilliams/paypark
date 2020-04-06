class CreateDrivers < ActiveRecord::Migration[5.2]
  def change
    create_table :drivers do |t|
      t.belongs_to :user, foreign_key: true
      t.string :registration_number

      t.timestamps
    end
  end
end
