class AddPerentIdToRoles < ActiveRecord::Migration[5.1]
  def change
    add_reference :roles, :parent, type: :uuid, index: true
  end
end
