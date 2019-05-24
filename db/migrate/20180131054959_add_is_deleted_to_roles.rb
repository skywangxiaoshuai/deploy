class AddIsDeletedToRoles < ActiveRecord::Migration[5.1]
  def change
    add_column :roles, :is_deleted, :boolean, default: false, comment: "用于标记该角色是否被删除"
  end
end
