class CreateDepartmentDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :department_devices, id: :uuid do |t|
      t.string :acknowledgment, comment: "门店针对每个设备可以设置不同的答谢语"
      t.references :department, type: :uuid, index: true, comment: "department外键"
      t.references :device, type: :string, index: true, comment: "device外键"

      t.timestamps
    end
  end
end
