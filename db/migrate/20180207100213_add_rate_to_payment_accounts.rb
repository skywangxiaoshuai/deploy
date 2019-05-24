class AddRateToPaymentAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_accounts, :rate, :float
  end
end
