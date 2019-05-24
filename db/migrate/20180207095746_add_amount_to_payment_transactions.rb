class AddAmountToPaymentTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_transactions, :amount, :integer, comment: "流水金额"
  end
end
