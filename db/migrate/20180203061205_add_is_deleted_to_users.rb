class AddIsDeletedToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_deleted, :boolean, default: false, comment: "标记该用户是否被删除"
    add_index :users, :is_deleted
  end
end
