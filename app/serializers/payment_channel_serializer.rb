class PaymentChannelSerializer < ActiveModel::Serializer
  attributes :id, :name, :rate, :enabled, :description
end
