class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories, id: :string do |t|
      t.string :name
      t.references :parent, type: :string, index: true

      t.timestamps
    end
  end
end
