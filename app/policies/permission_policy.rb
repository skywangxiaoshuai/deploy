class PermissionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    user.permissions.pluck(:full_name).include?("查看权限列表")
  end
end
