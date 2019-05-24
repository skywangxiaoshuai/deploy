class PaymentAccount < ApplicationRecord
  default_scope -> {order(created_at: :desc)}

  belongs_to :payment_accountable, polymorphic: true, optional: true

  validates :account, uniqueness: {message: "帐号已经存在"}
  validates :name, length: {maximum: 30}
  # validates :channel_id, presence: {message: "渠道不能为空"}
  # validates :rate, presence: {message: "费率不能为空"}
  validate :create_validates, on: :create

  private

    def create_validates
      merchant = Merchant.find_by(id: merchant_id)
      unless merchant
        errors.add(:merchant_id, "该商户不存在")
      end
      channel = PaymentChannel.find_by(id: channel_id)
      unless channel
        errors.add(:channel_id, "该通道不存在")
      end
      payment_account = PaymentAccount.where(channel_id: channel_id, merchant_id: merchant_id)
      if payment_account.present?
        errors.add(:channel_id, "该商户在该支付渠道下已经创建了账户")
      end
    end
end
