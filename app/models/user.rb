class User < ApplicationRecord
  enum audit: {verifing: 1, verified: 2, reject: 3}

  default_scope -> {order(created_at: :desc)}

  belongs_to :userable, polymorphic: true, optional: true

  #用户之间存在上下级关系
  belongs_to :parent, class_name: "User", optional: true
  has_many :children, class_name: "User", foreign_key: "parent_id"

  #用户与角色为多对多关系
  has_and_belongs_to_many :roles, join_table: :users_roles

  belongs_to :department, optional: true

  #Password
  has_secure_password

  validates :name, length: {maximum: 30, message: "名称不能超过30个字符"}
  validates :login_name, presence: {message: "登录名不能为空"}, uniqueness: {message: "登录名已经存在"}
  validates :description, length: {maximum: 100, message: "长度不能超过100个字符"}
  # validates :department_id, presence: {message: "所属部门不能为空"}
  validates :password, presence: {message: "密码不能为空"},
            format: { with:  /(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,14}/, message: "密码为6~14位数字与字母组合" },
            allow_nil: true
  validates :contact_phone, format: {with: /\A1[3-8]\d{9}\z/, message: "手机号格式不正确"}

  has_attached_file :avatar,
                    :styles => {medium: "300x300>"},
                    :default_style => :medium,
                    :path => ":rails_root/public/system/:class/:id/:attachment/:style.:extension",
                    :url => "/system/:class/:id/:attachment/:style.:extension",
                    :default_url => "/system/missing.jpg"

  validates_attachment :avatar,
                       content_type: { content_type: /\Aimage\/.*\z/ },
                       size: { in: 0..1.megabytes, message: "图片大小不能超过1m" }
                       # size: { in: 0..500.kilobytes, message: "图片大小不能超过500k" }

  #取出用户的权限
  def permissions
    roles.where(is_deleted: false, is_disabled: false).collect(&:permissions).flatten.uniq
  end

  #给用户添加角色
  def add_role(role_ids)
    role_ids.each do |id|
      role = Role.find_by(id: id)
      return false unless role
      self.roles << role
    end
    true
  end
end


