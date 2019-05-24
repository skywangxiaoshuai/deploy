class AddMerchantIdToPaymentWechatAccountApplications < ActiveRecord::Migration[5.1]
  def change
    add_reference :payment_wechat_account_applications, :merchant, type: :uuid, index: true
  end
end
