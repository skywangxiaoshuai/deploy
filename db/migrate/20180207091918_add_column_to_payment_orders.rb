class AddColumnToPaymentOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_orders, :merchant_trade_no, :string, index: true, comment: "商户订单号"
    add_column :payment_orders, :payment_channel_id, :integer, index: true, comment: "支付通道id"
    add_column :payment_orders, :payment_method_id, :integer, index: true, comment: "支付方式id"
    add_column :payment_orders, :rate, :float, comment: "费率"
    add_column :payment_orders, :transcation_id, :string, index: true, comment: "支付方的流水号"
    add_column :payment_orders, :consumer_id, :string, comment: "消费者标识"
    add_column :payment_orders, :merchant_no, :string, comment: "商户号"
    add_column :payment_orders, :trade_type, :string, comment: "交易类型"
    add_column :payment_orders, :bank_type, :string, comment: "银行类型"
    add_column :payment_orders, :total_amount, :integer, comment: "总金额，单位是分"
    add_column :payment_orders, :cash_amount, :integer, comment: "现金支付金额，单位是分"
    add_column :payment_orders, :status, :integer, index: true, comment: "订单状态，1支付成功，2支付失败，3未支付，4订单已关闭，5订单已撤销，6订单已退款，7订单状态未知"
    add_column :payment_orders, :merchant_refund_no, :string, index: true, comment: "商户退款单号"
    add_column :payment_orders, :refund_amount, :integer, index: true, comment: "退款金额，单位是分"
    add_column :payment_orders, :refund_type, :integer, index: true, comment: "退款状态, 1退款成功，2退款失败"
    add_column :payment_orders, :user_id, :uuid, index: true, comment: "门店店员id"
    add_reference :payment_orders, :store, type: :uuid, index: true, comment: "门店外键"
    add_reference :payment_orders, :merchant, type: :uuid, index: true, comment: "商户外键"
  end
end
