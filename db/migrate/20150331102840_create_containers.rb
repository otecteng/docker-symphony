class CreateContainers < ActiveRecord::Migration
  def change
    create_table :containers do |t|
      t.string :name
      t.string :uuid    
      t.integer :docker_id
      t.integer :tag_id
      t.text :command
      t.text :env
      t.text :link
      t.text :host_config
      t.text :network_settings
      t.text :state
      t.timestamps
    end
  end
end
