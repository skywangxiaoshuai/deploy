class CreatePaymentWechatAccountApplications < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_wechat_account_applications, id: :uuid do |t|
      t.string :name

      t.timestamps
    end
  end
end
