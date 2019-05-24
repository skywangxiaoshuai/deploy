class CreateStoresMaterial < ActiveRecord::Migration[5.1]
  def change
    create_table :stores_materials, id: false do |t|
      t.references :store, type: :uuid, index: true
      t.references :material, type: :uuid, index: true
    end
  end
end
