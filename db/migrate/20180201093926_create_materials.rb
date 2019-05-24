class CreateMaterials < ActiveRecord::Migration[5.1]
  def change
    create_table :materials, id: :uuid do |t|
      t.string :name

      t.references :materialable, polymorphic: true, index: true, type: :uuid

      t.timestamps
    end
  end
end
