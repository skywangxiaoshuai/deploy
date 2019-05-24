class CreatePaymentMethodChannels < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_method_channels, id: :uuid do |t|
      t.float :rate
      t.integer :payment_method_id
      t.integer :payment_channel_id
      t.references :merchant, type: :uuid, index: true

      t.timestamps
    end
    add_index :payment_method_channels, :payment_method_id
    add_index :payment_method_channels, :payment_channel_id
  end
end
