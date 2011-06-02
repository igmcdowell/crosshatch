class AddNeededFieldsToUsers < ActiveRecord::Migration
  def self.up  
    create_table :users do |t|
      t.boolean :tw_linked
      t.integer :tw_id, :unique => true, :limit => 8
      t.string :tw_handle
      t.string :tw_secret
      t.string :tw_token
      t.string :tw_img
      t.string :fb_token
      t.boolean :fb_linked
      t.integer :last_post, :limit => 8
    end
  end

  def self.down
    drop_table :users
  end
end
