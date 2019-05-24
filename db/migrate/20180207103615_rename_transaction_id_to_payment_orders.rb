class RenameTransactionIdToPaymentOrders < ActiveRecord::Migration[5.1]
  def change
    rename_column :payment_orders, :transcation_id, :transaction_id
  end
end
