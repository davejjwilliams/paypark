class AddCarInfoToDriver < ActiveRecord::Migration[5.2]
  def change
    add_column :drivers, :car_info, :string, null: false, default: ""
  end
end
