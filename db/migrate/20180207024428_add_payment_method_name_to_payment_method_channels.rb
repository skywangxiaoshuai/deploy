class AddPaymentMethodNameToPaymentMethodChannels < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_method_channels, :payment_method_name, :string
  end
end
