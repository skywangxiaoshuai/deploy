class AddReferencesToAgents < ActiveRecord::Migration[5.1]
  def change
    add_reference :agents, :platform, type: :uuid, index: true
  end
end
