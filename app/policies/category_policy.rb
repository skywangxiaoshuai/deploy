class CategoryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def get_sub_categories?
    user.permissions.pluck(:full_name).include?("添加角色") #查看商户类型列表
  end
end
