class CreateDockers < ActiveRecord::Migration
  def change
    create_table :dockers do |t|
      t.string :name

      t.timestamps
    end
  end
end
