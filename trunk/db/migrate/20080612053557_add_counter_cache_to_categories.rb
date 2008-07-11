class AddCounterCacheToCategories < ActiveRecord::Migration
  def self.up
  	add_column :categories, :posts_count, :integer, :default => 0
  	Category.all.each { |c| Category.update_counters c.id, :posts_count => c.posts.count }
  end

  def self.down
  	remove_column :categories, :posts_count
  end
end
