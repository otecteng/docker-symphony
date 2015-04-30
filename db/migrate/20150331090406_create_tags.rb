class CreateTags < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :name
      t.string :parent
      t.string :created
      t.string :container
      t.text :container_config
      t.text :docker_file
      t.string :uuid
      t.integer :docker_id
      t.timestamps
    end

    create_table :tags do |t|
      t.string :name
      t.string :uuid
      t.integer :repository_id
      t.integer :image_id
      t.timestamps
    end


  end
end
