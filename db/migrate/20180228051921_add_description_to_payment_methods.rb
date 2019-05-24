class AddDescriptionToPaymentMethods < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_methods, :description, :string, comment: "支付方式描述"
  end
end
