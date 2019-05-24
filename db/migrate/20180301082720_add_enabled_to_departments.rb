class AddEnabledToDepartments < ActiveRecord::Migration[5.1]
  def change
    add_column :departments, :enabled, :boolean, default: true, comment: "是否启用"
  end
end
