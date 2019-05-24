class AddPaymentOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_orders, id: :uuid do |t|
      t.string "merchant_trade_no", index: true, comment: "商户订单号"
      t.integer "payment_channel_id", comment: "支付通道id"
      t.integer "payment_method_id", comment: "支付方式id"
      t.float "rate", comment: "费率"
      t.string "channel_transaction_id", comment: "渠道方交易流水号"
      t.string "consumer_id", comment: "消费者标识"
      t.string "merchant_no", index: true, comment: "商户号"
      t.string "trade_type", comment: "交易类型"
      t.string "bank_type", comment: "银行类型"
      t.integer "total_amount", comment: "总金额，单位是分"
      # t.integer "cash_amount", comment: "现金支付金额，单位是分"
      t.integer "status", index: true, comment: "订单状态，1支付成功，2支付失败，3未支付，4订单已关闭，5订单已撤销，6订单已退款，7订单状态未知"
      t.string "merchant_refund_no", comment: "商户退款单号"
      t.integer "refund_amount", comment: "退款金额，单位是分"
      t.integer "refund_status", index: true, comment: "退款状态, 1退款成功，2退款失败"
      t.uuid "user_id", comment: "门店店员id"
      t.references :store, type: :uuid, index: true, comment: "门店外键"
      t.references :merchant, type: :uuid, index: true, comment: "商户外键"
      t.integer :receipt_amount, comment: '实收金额'

      t.timestamps
    end
  end
end
