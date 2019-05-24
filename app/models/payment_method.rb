class PaymentMethod < ApplicationRecord
  has_and_belongs_to_many :payment_channels, join_table: :payment_channel_methods

  validates :name, uniqueness: {message: "支付方式已存在"}, presence: {message: "名称不能为空"}
  validates :description, presence: {message: "描述不能为空"}
end
