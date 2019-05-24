class RolePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.permissions.pluck(:full_name).include?("添加角色")
  end

  def get_relative_roles?
    user.permissions.pluck(:full_name).include?("添加角色") #查看相对应的角色
  end

  def index?
    user.permissions.pluck(:full_name).include?("添加角色") #查看所有角色
  end

  def show?
    user.permissions.pluck(:full_name).include?("添加角色") #查看角色
  end

  def update?
    user.permissions.pluck(:full_name).include?("添加角色") #更新角色
  end

  def destroy?
    user.permissions.pluck(:full_name).include?("添加角色") #删除角色
  end

  def disable_role?
    user.permissions.pluck(:full_name).include?("添加角色") #停用角色
  end

  def enable_role?
    user.permissions.pluck(:full_name).include?("添加角色") #启用角色
  end

  def add_permissions?
    user.permissions.pluck(:full_name).include?("添加角色") #角色授权
  end
end
