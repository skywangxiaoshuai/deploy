class CreatePaymentTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_transactions, id: :uuid do |t|
      t.string :out_trade_no
      t.integer :total_fee
      t.uuid :payment_method_id
      t.uuid :payment_channel_id
      t.uuid :merchant_id, index: true
      t.references :store, type: :uuid, index: true

      t.timestamps
    end
    add_index :payment_transactions, :out_trade_no
  end
end
