class PaymentOrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def refund?
    # flag1 = user.permissions.pluck(:full_name).include?("添加角色") #退款
    # flag2 = user.userable_id == record.merchant_id
    # flag1 && flag2
    true
  end
end
