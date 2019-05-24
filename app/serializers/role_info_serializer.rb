class RoleInfoSerializer < ActiveModel::Serializer
  attributes :id, :name, :org_type, :is_disabled, :level, :description, :permissions

  def permissions
    object.permissions.pluck(:full_name)
    # json = {:"系统权限" => {}}
    # parent = Permission.first
    # parent.children.each do |child|
    #   json[:"系统权限"][child] = child.children
    # end
    # json
  end

end
