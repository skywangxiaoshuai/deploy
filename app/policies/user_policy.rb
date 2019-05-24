class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    user.permissions.pluck(:full_name).include?("添加角色") #查看用户列表
  end

  def show?
    user.permissions.pluck(:full_name).include?("添加角色") && user.userable == record.userable #查看用户详情
  end

  def update?
    user.permissions.pluck(:full_name).include?("添加角色") && user.userable == record.userable #更新用户
  end

  def destroy?
    flag = user.permissions.pluck(:full_name).include?("添加角色") #删除用户
    #如果当前登录用户是平台管理员，则可以删除所有用户
    if flag && user.userable_type == "Platform"
      return true
      #如果当前登录用户是代理商管理员，则只能删除该代理商下的用户
      #如果当前登录用户是商户管理员，则只能删除该商户下的用户
    elsif flag && user.userable == record.userable
      return true
    else
      return false
    end
  end

  def create?
    user.permissions.pluck(:full_name).include?("添加角色") #添加用户
  end

  def reset_password?
    permissions = user.permissions.pluck(:full_name)
    #如果当前登录用户是平台管理员，则可以重置所有用户的密码
    if permissions.include?("添加角色") && user.userable_type == "Platform" #重置密码
      return true
    #如果当前登录用户是代理商管理员，则只能重置该代理商下的用户的密码
    #如果当前登录用户是商户管理员，则只能重置该商户下的用户的密码
    elsif permissions.include?("添加角色") && user.userable == record.userable #重置密码
      return true
    else
      return false
    end
  end

  def update_profile?
    user.id == record.id
  end

  def modify_password?
    user.id == record.id
  end
end
