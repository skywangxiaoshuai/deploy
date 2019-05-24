class CreatePermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :permissions, id: :uuid do |t|
      t.string :short_name, comment: "权限的简称，用于前端直接拿去显示"
      t.string :full_name, comment: "权限的全称，用于后端判断接口权限"
      t.references :parent, type: :uuid, index: true
      t.integer :level, comment: "代表该权限是几级菜单"

      t.timestamps
    end
  end
end
