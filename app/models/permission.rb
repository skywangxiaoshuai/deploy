class Permission < ApplicationRecord

  #权限之间存在上下级关系
  belongs_to :parent, class_name: "Permission", optional: true
  has_many :children, class_name: "Permission", foreign_key: "parent_id"

  has_many :roles_permissions, dependent: :destroy
  has_many :roles, :through => :roles_permissions

  # validates :name, uniqueness: true, length: {maximum: 15}
end
