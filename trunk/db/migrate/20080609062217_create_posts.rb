class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.string :category_id, :integer
      t.string :state
      t.string :status, :default => 'new'
      t.integer :point, :default => 0
      t.integer :read_count, :default => 0
      t.boolean :sticky, :default => false
      t.integer :comments_count, :default => 0
			t.boolean :secured, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
