class AddAccountToPaymentAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_accounts, :account, :string
  end
end
