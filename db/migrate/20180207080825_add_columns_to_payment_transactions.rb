class AddColumnsToPaymentTransactions < ActiveRecord::Migration[5.1]
  def change
    remove_column :payment_transactions, :out_trade_no
    remove_column :payment_transactions, :total_fee
    remove_column :payment_transactions, :payment_method_id
    remove_column :payment_transactions, :payment_channel_id
    remove_column :payment_transactions, :merchant_id
    remove_column :payment_transactions, :store_id

    add_column :payment_transactions, :merchant_trade_no, :string, comment: "商户订单号"
    add_reference :payment_transactions, :merchant, type: :uuid, index: true, comment: "商户外键"
    add_column :payment_transactions, :business_type, :integer, index: true, comment: "业务类型，交易1，退款2，扣除交易手续费3，退回交易手续费4"
    add_column :payment_transactions, :income_expenses_type, :integer, index: true, comment: "收支类型，1收入，2支出"
    add_column :payment_transactions, :rate, :float, comment: "费率"
    add_column :payment_transactions, :payment_channel_id, :integer, comment: "支付通道id"
    add_column :payment_transactions, :payment_method_id, :integer, comment: "支付方式id"

  end
end
