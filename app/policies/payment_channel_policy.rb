class PaymentChannelPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    user.permissions.pluck(:full_name).include?("添加角色") #返回所有支付通道
  end

  def create?
    user.permissions.pluck(:full_name).include?("添加角色") #添加支付通道
  end

  def configurate_channel?
    user.permissions.pluck(:full_name).include?("添加角色") #配置支付通道
  end

  def get_payment_method_channels?
    user.permissions.pluck(:full_name).include?("添加角色") #返回某个支付方式对应的支付通道
  end
end
