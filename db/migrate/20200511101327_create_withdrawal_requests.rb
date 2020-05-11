class CreateWithdrawalRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :withdrawal_requests do |t|
      t.belongs_to :homeowner, foreign_key: true
      t.decimal :amount
      t.date :request_date

      t.timestamps
    end
  end
end
