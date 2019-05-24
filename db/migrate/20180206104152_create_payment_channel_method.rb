class CreatePaymentChannelMethod < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_channel_methods, id: false do |t|
      t.references :payment_channel, type: :integer, index: true
      t.references :payment_method, type: :integer, index: true
    end
  end
end
