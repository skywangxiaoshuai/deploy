class AddDepartmentIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :department, type: :uuid, index: true, comment: "department的外键"
  end
end
