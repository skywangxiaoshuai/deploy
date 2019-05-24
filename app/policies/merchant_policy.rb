class MerchantPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.permissions.pluck(:full_name).include?("添加角色") #添加商户
  end

  def search_by_name?
    user.permissions.pluck(:full_name).include?("添加角色") #根据name模糊查询商户（平台管理员权限）
  end
end
