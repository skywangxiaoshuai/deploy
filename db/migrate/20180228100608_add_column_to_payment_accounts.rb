class AddColumnToPaymentAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_accounts, :name, :string, comment: "账户名称"
    add_column :payment_accounts, :channel_id, :integer, index: true, comment: "通道id"
    add_column :payment_accounts, :enabled, :boolean, default: true, comment: "商户账户是否启用"
  end
end
