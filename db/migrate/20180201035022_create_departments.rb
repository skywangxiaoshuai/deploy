class CreateDepartments < ActiveRecord::Migration[5.1]
  def change
    create_table :departments, id: :uuid do |t|
      t.string :name, comment: "部门名称"
      t.integer :department_type, comment: "1职能部门，2业务部门"
      t.boolean :is_store, default: false, comment: "用于标记该部门是不是门店"

      t.references :departmentable, polymorphic: true, index: true, type: :uuid

      t.timestamps
    end
  end
end
