class RenameTransactionIdFromPaymentOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :payment_orders, :transaction_id
    remove_column :payment_orders, :cash_amount
    add_column :payment_orders, :channel_transaction_id, :string, comment: "渠道方交易流水号"
    add_column :payment_orders, :receipt_amount, :integer, comment: "实收金额，单位是分"
  end
end
