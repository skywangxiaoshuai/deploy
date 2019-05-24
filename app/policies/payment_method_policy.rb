class PaymentMethodPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    user.permissions.pluck(:full_name).include?("添加角色") #返回支付方式列表
  end

  def create?
    user.permissions.pluck(:full_name).include?("添加角色") #添加支付方式
  end
end
