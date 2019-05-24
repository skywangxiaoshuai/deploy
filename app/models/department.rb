class Department < ApplicationRecord
  enum department_type: {FD: 1, BD: 2} #functional_department职能部门， business_division业务部门
  belongs_to :departmentable, polymorphic: true
  has_many :users
  has_and_belongs_to_many :materials, join_table: :stores_materials,
                          foreign_key: :store_id

  has_many :payment_orders, foreign_key: :store_id
  has_many :payment_transactions, foreign_key: :store_id
  # has_many :department_devices
  # has_many :devices, :through => :department_devices

  accepts_nested_attributes_for :materials

  validates :name, presence: {message: "门店名称不能为空"}, length: {maximum: 30, message: "长度不能超过30个字符"},
            uniqueness: {message: "门店名称已经存在"}
  validates :description, length: {maximum: 30, message: "长度不能超过200个字符"}
  validates :address, presence: {message: "详细地址不能为空"}, length: {maximum: 30, message: "长度不能超过30个字符"}
  validates :contact_phone, presence: {message: "门店电话不能为空"},
            format: { with: /((\A[0]\d{9,11}\z)|(\A1[3-8]\d{9}\z))/, message: "电话格式不正确" }
end
