class AddDiggsCountToPost < ActiveRecord::Migration
  def self.up
  	add_column :posts, :diggs_count, :integer, :default => 0
  	Post.all.each { |p| Post.update_counters p.id, :diggs_count => p.diggs.count }
  end

  def self.down
  	remove_column :posts, :diggs_count
  end
end
