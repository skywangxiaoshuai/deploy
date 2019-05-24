class RemoveRateFormPaymentTransactions < ActiveRecord::Migration[5.1]
  def change
    remove_column :payment_transactions, :rate, :float
    rename_column :payment_transactions, :transaction_id, :channel_transaction_id
  end
end
