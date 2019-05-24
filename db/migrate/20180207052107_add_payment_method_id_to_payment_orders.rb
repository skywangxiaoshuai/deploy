class AddPaymentMethodIdToPaymentOrders < ActiveRecord::Migration[5.1]
  def change
    remove_reference :payment_orders, :payment_method_id
    remove_reference :payment_orders, :payment_channel_id
    add_column :payment_orders, :payment_channel_id, :integer, index: true
    add_column :payment_orders, :payment_method_id, :integer, index: true
  end
end
