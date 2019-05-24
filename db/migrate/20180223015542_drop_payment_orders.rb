class DropPaymentOrders < ActiveRecord::Migration[5.1]
  def change
    drop_table :payment_orders
  end
end
