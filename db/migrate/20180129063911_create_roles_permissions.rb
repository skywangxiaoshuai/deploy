class CreateRolesPermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :roles_permissions, id: :uuid do |t|
      t.references :permission, type: :uuid
      t.references :role, type: :uuid

      t.timestamps
    end

  end
end
