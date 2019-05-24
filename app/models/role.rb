class Role < ApplicationRecord
  #admin 管理员， company_leader 公司领导， department_leader 部门领导， employee 一线员工
  enum level: {admin: 0, company_leader: 1, department_leader: 2, employee: 3}
  enum org_type: {platform: 1, agent: 2, merchant: 3}


  scope :PLATFORM, -> { all.order(org_type: :asc).where("is_deleted = ? and is_disabled = ?", false, false).
                        order("org_type").order("level") }
  scope :AGENT, -> { where("org_type = ? and is_deleted = ? and is_disabled = ?", 2, false, false) }
  scope :MERCHANT, -> { where("org_type = ? and is_deleted = ? and is_disabled = ?", 3, false, false) }

  has_and_belongs_to_many :users, :join_table => :users_roles

  #Role之间存在上下级关系
  belongs_to :parent, class_name: "Role", optional: true
  has_many :children, class_name: "Role", foreign_key: "parent_id"

  has_many :roles_permissions
  has_many :permissions, :through => :roles_permissions

  validates :name, presence: {message: "名称不能为空"}, length: {maximum: 15, message: "名称长度不能超过15个字"}
  validates :description, presence: {message: "描述不能为空"}, length: {maximum: 100, message: "名称长度不能超过100个字"}
  validates :org_type, presence: {message: "机构类型不能为空"}
  validates :level, presence: {message: "角色级别不能为空"}


  def self.include?(parameters = {})
    Role.where(org_type: parameters[:org_type]).where(is_deleted: false)
        .pluck(:name).include?(parameters[:name])
  end

  def add_permissions(permissions)
    permissions.each do |p|
      self.roles_permissions.create(permission_id: p)
    end
  end

  def delete_permissions
    roles_permissions.each do |rp|
      rp.delete
    end
  end

end
