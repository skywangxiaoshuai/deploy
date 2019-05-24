class AddPaymentChannelNameToPaymentMethodChannels < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_method_channels, :payment_channel_name, :string
  end
end
