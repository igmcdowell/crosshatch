class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :twitterhandle
      t.integer :twitterid
      t.boolean :linkats
      t.boolean :linkhashes

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
