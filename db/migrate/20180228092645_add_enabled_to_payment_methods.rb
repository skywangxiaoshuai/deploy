class AddEnabledToPaymentMethods < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_methods, :enabled, :boolean, default: true, comment: "是否启用,true为启用 false为禁用"
  end
end
