class CreatePlatforms < ActiveRecord::Migration[5.1]
  def change
    create_table :platforms, id: :uuid do |t|
      t.string :name

      t.timestamps
    end
  end
end
