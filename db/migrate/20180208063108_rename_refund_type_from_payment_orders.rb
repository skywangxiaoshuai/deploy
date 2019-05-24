class RenameRefundTypeFromPaymentOrders < ActiveRecord::Migration[5.1]
  def change
    rename_column :payment_orders, :refund_type, :refund_status
  end
end
