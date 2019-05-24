class PaymentMethodChannel < ApplicationRecord
  belongs_to :merchant

  validate :create_validation, on: :create

  private

    def create_validation
      if payment_channel_name.nil?
        errors.add(:payment_channel_id, "支付通道不存在")
      end
      if payment_method_id.nil?
        errors.add(:payment_method_id, "支付方式不存在")
      end
      if rate.nil?
        errors.add(:rate, "请先添加该通道对应的商户账户")
      end
      payment_method_channel = PaymentMethodChannel.where(merchant_id: merchant_id, payment_method_id: payment_method_id)
      if payment_method_channel.present?
        errors.add(:base, "已经添加了该支付方式，不能重复添加")
      end
    end
end
