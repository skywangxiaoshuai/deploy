class DepartmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create_user?
    flag1 = user.permissions.pluck(:full_name).include?("添加角色") #添加门店店员
    #当前用户只能给自己商户下的门店添加店员
    flag2 = @current_user.userable.id == @store.departmentable.id
    if flag1 && flag2
      true
    else
      false
    end
  end

  def create_store?
    user.permissions.pluck(:full_name).include?("添加角色") #添加门店
  end

  def index_stores?
    user.permissions.pluck(:full_name).include?("添加角色") #返回门店列表
  end

  def get_store_by_id?
    user.permissions.pluck(:full_name).include?("添加角色") #查看门店信息
  end

  def index_stores_users?
    user.permissions.pluck(:full_name).include?("添加角色") #返回店员列表
  end

  def get_store_user_by_id?
    user.permissions.pluck(:full_name).include?("添加角色") #查看店员信息
  end

  def update_store_user?
    user.permissions.pluck(:full_name).include?("添加角色") #修改店员信息
  end

  def update_store?
    flag1 = user.permissions.pluck(:full_name).include?("添加角色") #修改门店信息
    flag2 = user.userable.id == record.departmentable.id
    if flag1 && flag2
      true
    else
      false
    end
  end

  def bind_device?
    flag1 = user.permissions.pluck(:full_name).include?("添加角色") #绑定设备
    flag2 = user.roles.pluck(:org_type, :level).include?(["merchant", "admin"]) #判断是不是商户管理员
    flag3 = record.departmentable.id == user.userable.id #该用户是商户管理员时，判断该门店是不是该用户所属商户的
    flag4 = record.id == user.department_id #该用户是店长或者店员时，判断该门店是不是该用户所属的门店
    if flag1 && flag2 && flag3
      true
    elsif flag1 && flag4
      true
    else
      false
    end
  end

  def index_devices?
    flag1 = user.permissions.pluck(:full_name).include?("添加角色") #返回设备列表
    flag2 = user.roles.pluck(:org_type, :level).include?(["merchant", "admin"]) #判断是不是商户管理员
    flag3 = record.departmentable.id == user.userable.id #该用户是商户管理员时，判断该门店是不是该用户所属商户的
    flag4 = record.id == user.department_id #该用户是店长或者店员时，判断该门店是不是该用户所属的门店
    if flag1 && flag2 && flag3
      true
    elsif flag1 && flag4
      true
    else
      false
    end
  end

  def unbind_device?
    flag1 = user.permissions.pluck(:full_name).include?("添加角色") #解绑设备
    flag2 = user.roles.pluck(:org_type, :level).include?(["merchant", "admin"]) #判断是不是商户管理员
    flag3 = record.departmentable.id == user.userable.id #该用户是商户管理员时，判断该门店是不是该用户所属商户的
    flag4 = record.id == user.department_id #该用户是店长或者店员时，判断该门店是不是该用户所属的门店
    if flag1 && flag2 && flag3
      true
    elsif flag1 && flag4
      true
    else
      false
    end
  end


end
