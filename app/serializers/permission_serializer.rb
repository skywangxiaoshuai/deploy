class PermissionSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :level
end
