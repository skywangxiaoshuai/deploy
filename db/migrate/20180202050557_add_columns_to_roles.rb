
class AddColumnsToRoles < ActiveRecord::Migration[5.1]
  def change
    add_column :roles, :description, :string, comment: "角色描述"
    remove_column :roles, :belongs_to
    add_column :roles, :org_type, :integer, index: true, comment: "角色所属机构类型，1平台，2代理商，3商户"
    add_column :roles, :is_disabled, :boolean, index: true, default: false, comment: "是否被停用"
  end
end
