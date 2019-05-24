class Material < ApplicationRecord
  belongs_to :materialable, polymorphic: true, optional: true
  has_and_belongs_to_many :payment_alipay_account_applications,
                          join_table: :payment_alipay_account_applications_materials

  has_and_belongs_to_many :payment_wechat_account_applications,
                          join_table: :payment_wechat_account_applications_materials

  has_and_belongs_to_many :payment_heli_account_applications,
                          join_table: :payment_heli_account_applications_materials

  has_and_belongs_to_many :stores, class_name: "Department", optional: true,
                          join_table: :stores_materials, :association_foreign_key => "store_id"

  has_attached_file :picture,
                    :styles => {large: "750x750>"},
                    :default_style => :large,
                    :path => ":rails_root/public/system/:class/:id/:attachment/:style.:extension",
                    :url => "/system/:class/:id/:attachment/:style.:extension",
                    :default_url => "/system/missing.jpg"

  validates_attachment :picture,
                       content_type: { content_type: /\Aimage\/.*\z/ },
                       size: { in: 0..500.kilobytes, message: "图片大小不能超过500k" }

end
