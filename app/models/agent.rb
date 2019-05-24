class Agent < ApplicationRecord
  enum audit: {verifing: 1, verified: 2, reject: 3} #审核中、审核成功、审核失败
  enum agent_type: {enterprise: 1, personal: 2} #企业代理、个人代理

  has_many :users, as: :userable
  has_many :departments, as: :departmentable
  has_many :materials, as: :materialable
  has_many :merchants
  belongs_to :platform

  accepts_nested_attributes_for :users

  validates :name, uniqueness: {message: "代理商名称已经存在"}, presence: {message: '代理商名称不能为空'},
            length: {maximum: 30, message: "代理商名称不能超过30个字符"}
  validates :agent_type, presence: {message: '代理商类型不能为空'}
  validates :short_name, uniqueness: {message: "代理商简称已经存在"}, presence: {message: '代理商简称不能为空'},
            length: {maximum: 30, message: "代理商简称不能超过30个字符"}

  def users_attributes=(attribute_sets)
    super(
        attribute_sets.map do |attribute_set|
          attribute_set.merge(userable: self)
        end
    )
  end
end
