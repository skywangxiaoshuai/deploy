class PaymentAccountPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.permissions.pluck(:full_name).include?("添加角色") #添加商户账户（平台管理员）
  end

  def index?
    user.permissions.pluck(:full_name).include?("添加角色") #返回商户账户列表（平台管理员）
  end
end
