class AddLevelToRoles < ActiveRecord::Migration[5.1]
  def change
    add_column :roles, :level, :integer, comment: "角色等级：1公司领导，2部门领导，3一线员工"
    add_index :roles, :level
  end
end
