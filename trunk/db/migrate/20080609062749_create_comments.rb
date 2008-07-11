class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :content
      t.datetime :created_at
			t.integer :post_id
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
