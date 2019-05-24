class StoreUserSerializer < ActiveModel::Serializer
  attributes :id, :login_name, :name, :contact_phone, :role, :store

  def role
    object.roles.pluck(:name)
  end

  def store
    object.department.name
  end

end
