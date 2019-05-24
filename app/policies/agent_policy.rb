class AgentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.permissions.pluck(:full_name).include?("添加角色") #添加代理商
  end

  def index?
    user.permissions.pluck(:full_name).include?("添加角色") #查看代理商列表
  end

  def show?
    user.permissions.pluck(:full_name).include?("添加角色") #查看代理商详情
  end
end
