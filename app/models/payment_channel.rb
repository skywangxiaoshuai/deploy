class PaymentChannel < ApplicationRecord
  has_and_belongs_to_many :payment_methods, join_table: :payment_channel_methods

  validates :name, uniqueness: {message: "支付通道已存在"}, presence: {message: "名称不能为空"}
  validates :description, presence: {message: "描述不能为空"}
  validates :rate, presence: {message: "费率不能为空"}
  validates :application_material, presence: {message: "申请资料不能为空"}
end
