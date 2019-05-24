class AddIsDisabledToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_disabled, :boolean, default: false, comment: "标记该用户是否启用"
    add_column :users, :audit, :integer, index: true, default: 2, comment: "审核状态：1审核中，2审核通过，3审核失败"
    add_column :users, :is_admin, :boolean, index: true, default: false, comment: "标记该用户是不是对应平台的最初管理员"
  end
end
