class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table(:roles, id: :uuid) do  |t|
      t.string :name, comment: "角色名称"
      # t.string :created_by, comment: "创建人"
      t.string :belongs_to, comment: "该角色属于谁，例：PLATFORM, AGENT, MERCHANT", index: true

      t.timestamps
    end

    create_table(:users_roles, :id => false) do |t|
      t.references :user, type: :uuid
      t.references :role, type: :uuid
    end

    add_index(:roles, :name)
    add_index(:users_roles, [ :user_id, :role_id ])
  end
end
