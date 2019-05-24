class AddColumnsToDepartments < ActiveRecord::Migration[5.1]
  def change
    add_column :departments, :description, :string, comment: "简介"
    add_column :departments, :address, :string, comment: "详细地址"
    add_column :departments, :contact_phone, :string, comment: "联系电话"
  end
end
