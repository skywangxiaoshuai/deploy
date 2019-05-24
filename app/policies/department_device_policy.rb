class DepartmentDevicePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index_department_devices?
    user.permissions.pluck(:full_name).include?("添加角色") #返回设备列表
  end
end
