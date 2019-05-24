class Merchant < ApplicationRecord
  enum audit: {verifing: 1, verified: 2, reject: 3} #审核中、审核成功、审核失败
  has_many :users, as: :userable
  has_many :departments, as: :departmentable
  has_many :materials, as: :materialable
  belongs_to :agent

  has_one :payment_wechat_account_application
  has_one :payment_alipay_account_application
  has_one :payment_heli_account_application
  has_many :payment_method_channels
  has_many :payment_transactions
  has_many :payment_orders

  has_attached_file :brand_logo,
                    :styles => {medium: "300x300>"},
                    :default_style => :medium,
                    :path => ":rails_root/public/system/:class/:id/:attachment/:style.:extension",
                    :url => "/system/:class/:id/:attachment/:style.:extension",
                    :default_url => "/system/missing.jpg"

  accepts_nested_attributes_for :users

  validates :name, uniqueness: {message: "商户名称已经存在"}, presence: {message: '商户名称不能为空'},
            length: {maximum: 30, message: "商户名称不能超过30个字符"}
  validates :short_name, uniqueness: {message: "商户简称已经存在"}, presence: {message: '商户简称不能为空'},
            length: {maximum: 30, message: "商户简称不能超过30个字符"}
  validates :brand_name, presence: {message: "品牌名称不能为空"}, length: {maximum: 10, message: "不能超过10个字符"}


  validates_attachment :brand_logo,
                       content_type: {content_type: /\Aimage\/.*\z/},
                       size: {in: 0..500.kilobytes, message: "图片大小不能超过500k"}

  #多态关联accepts_nest_attributes_for用法 --begin--
  #has_one
  # def users_attributes=(attribute_set)
  #   super(attribute_set.merge(addressable: self))
  # end

  #has_many
  def users_attributes=(attribute_sets)
    super(
        attribute_sets.map do |attribute_set|
          attribute_set.merge(userable: self)
        end
    )
  end
  #多态关联accepts_nest_attributes_for用法 --end--

end
