class PaymentMethodChannelSerializer < ActiveModel::Serializer
  attributes :id, :payment_method_name, :payment_channel_name, :enabled
end
