class AddColumnsToPaymentAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_accounts, :ali_auth_token, :string, index: true, comment: "支付宝商户授权令牌，服务商代商户发起支付时使用"
    add_column :payment_accounts, :ali_refresh_token, :string, index: true, comment: "刷新令牌，用于刷新ali_auth_token"
  end
end
