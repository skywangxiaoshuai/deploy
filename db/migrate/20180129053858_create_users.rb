class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name
      t.string :login_name
      t.string :password_digest
      t.string :contact
      t.string :remark
      t.references :parent, type: :uuid, index: true
      t.references :userable, polymorphic: true, index: true, type: :uuid

      t.timestamps
    end
  end
end
