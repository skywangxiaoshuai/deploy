class AddColumnsToPaymentChannels < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_channels, :description, :text, comment: "支付通道描述"
    add_column :payment_channels, :rate, :string, comment: "支付通道费率范围描述"
    add_column :payment_channels, :application_material, :text, comment: "申请支付通道所需资料"
    add_column :payment_channels, :enabled, :boolean, defaule: true, comment: "支付通道是否启用"
  end
end
