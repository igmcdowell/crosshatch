class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :twitterid
      t.string :content
      t.boolean :handled

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
