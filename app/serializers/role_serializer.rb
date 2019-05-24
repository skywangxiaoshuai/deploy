class RoleSerializer < ActiveModel::Serializer
  attributes :id, :name, :org_type, :level, :description
end
