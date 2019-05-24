class AddReferencesToMerchants < ActiveRecord::Migration[5.1]
  def change
    add_reference :merchants, :agent, type: :uuid, index: true
  end
end
