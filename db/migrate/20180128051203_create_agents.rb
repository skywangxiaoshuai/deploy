class CreateAgents < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'uuid-ossp' unless extension_enabled?('uuid-ossp')
    enable_extension "plpgsql" unless extension_enabled?('plpgsql')
    enable_extension "pgcrypto" unless extension_enabled?('pgcrypto')
    create_table :agents, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string :name

      t.timestamps
    end
  end
end
