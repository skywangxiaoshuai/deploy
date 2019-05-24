class RemoveColumnsFromPaymentOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :payment_orders, :out_trade_no, :string
    remove_column :payment_orders, :total_fee, :integer
    remove_column :payment_orders, :merchant_id, :uuid
    remove_column :payment_orders, :store_id, :uuid
    remove_column :payment_orders, :status, :integer
    remove_column :payment_orders, :payment_channel_id, :integer
    remove_column :payment_orders, :payment_method_id, :integer

  end
end
