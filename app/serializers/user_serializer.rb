class UserSerializer < ActiveModel::Serializer
  attributes :id, :role, :name, :login_name, :avatar, :permissions

  def permissions
    object.permissions.pluck(:full_name)
  end

  #用户有多个角色时，返回角色等级最高的一个，level值越小，等级越高
  def role
    object.roles.where(is_deleted: false, is_disabled: false).order("level").first.name
  end
end
