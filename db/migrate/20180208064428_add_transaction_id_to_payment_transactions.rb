class AddTransactionIdToPaymentTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_transactions, :transaction_id, :string, comment: "渠道方交易流水号"
    add_index :payment_transactions, :transaction_id
  end
end
