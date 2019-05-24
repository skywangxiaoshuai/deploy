class PaymentMethodChannelPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    user.permissions.pluck(:full_name).include?("添加角色") #返回商户所有支付方式
  end

  def create?
    user.permissions.pluck(:full_name).include?("添加角色") #商户添加支付方式
  end
end
