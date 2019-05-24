class AddEnabledToPaymentMethodChannels < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_method_channels, :enabled, :boolean, default: true
  end
end
