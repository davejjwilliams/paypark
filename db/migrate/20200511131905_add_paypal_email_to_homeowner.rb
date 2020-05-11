class AddPaypalEmailToHomeowner < ActiveRecord::Migration[5.2]
  def change
    add_column :homeowners, :paypal_email, :string, null: false, default: ""
  end
end
