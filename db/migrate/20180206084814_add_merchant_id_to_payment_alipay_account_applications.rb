class AddMerchantIdToPaymentAlipayAccountApplications < ActiveRecord::Migration[5.1]
  def change
    add_reference :payment_alipay_account_applications, :merchant, type: :uuid, index: true
  end
end
