class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
			t.column :post_id, :integer
      t.timestamps
      # for attachment_fu
      t.string :content_type, :filename, :path, :thumbnail
      t.integer :parent_id, :size, :width, :height
    end
    add_column :posts, :attachments_count, :integer, :default => 0
  end

  def self.down
    drop_table :attachments
    remove_column :posts, :attachments_count
  end
end
