class AddPidToPaymentAlipayAccountApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_alipay_account_applications, :pid, :string, comment: "支付宝商户pid，2088开头"
    add_index :payment_alipay_account_applications, :pid
  end
end
