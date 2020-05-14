class ModifyHomeownerStartDateEndDate < ActiveRecord::Migration[5.2]
  def change
    remove_column :homeowners, :driveway_active
    add_column :homeowners, :active_start, :datetime
    add_column :homeowners, :active_end, :datetime
  end
end
