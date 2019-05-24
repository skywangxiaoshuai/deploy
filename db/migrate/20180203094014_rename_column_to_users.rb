class RenameColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :remark, :description
    remove_column :users, :contact
  end
end
