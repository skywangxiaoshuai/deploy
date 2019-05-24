class UserInfoSerializer < ActiveModel::Serializer
  attributes :id, :login_name, :name, :description, :department, :roles

  def department
    object.department.try(:name)
  end

  def roles
    object.roles.pluck(:name)
  end
end
