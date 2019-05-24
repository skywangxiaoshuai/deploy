class PaymentAccountSerializer < ActiveModel::Serializer
  attributes :id, :account, :enabled, :channel, :name

  def channel
    PaymentChannel.find_by(id: object.channel_id).try(:name)
  end
end
