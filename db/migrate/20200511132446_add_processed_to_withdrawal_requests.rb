class AddProcessedToWithdrawalRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :withdrawal_requests, :processed, :boolean, null: false, default: false
  end
end
