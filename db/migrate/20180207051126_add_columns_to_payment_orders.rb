class AddColumnsToPaymentOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_orders, :status, :integer
    remove_column :payment_orders, :payment_method_id
    remove_column :payment_orders, :payment_channel_id
    add_reference :payment_orders, :payment_method_id, type: :integer, index: true
    add_reference :payment_orders, :payment_channel_id, type: :integer, index: true
  end
end
