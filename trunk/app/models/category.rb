class Category < ActiveRecord::Base
	has_many :posts
	acts_as_tree :order => :name

	attr :posts_size, :all_posts_size

	def self.top
	  find(:all, :conditions => [ 'parent_id IS NULL' ])
	end

	def self.all_for(posts)
		categories = []
		grouped_posts = posts.group_by { |post| post.category_id }
		grouped_posts.each do |cate_id, posts|
			category = Category.find(cate_id) 
			category.posts_size = category.all_posts_size = posts.size
			categories << category
			expand_category(category, categories, category.posts_size)
		end
		return categories
	end

	def has_children?
	  children.size > 0
	end

	def posts_size=(count)
		@posts_size = count
	end

	def posts_size
		@posts_size || 0
	end

	def all_posts_size
		@all_posts_size || 0
	end

	def all_posts_size=(count)
		@all_posts_size = count
	end
	
	def to_s
		name
	end

	# Refactoring is required~!
	def breadcrumbs
		self.ancestors.reverse << self
		#(self.ancestors.reverse << self).collect(&:name)
	end

	private
	def self.expand_category(category, categories, increments=0)
		if parent = category.parent
			if stored_parent = categories.find { |c| c.id == parent.id }
				stored_parent.all_posts_size += increments
			else # new parent
				parent.posts_size = 0
				parent.all_posts_size = category.all_posts_size
				categories << parent
			end
			expand_category(parent, categories, increments)
		end	
	end
	
	def log_track(id, posts_size, all_posts_size)
		logger.debug "(#{id}): #{posts_size}/#{all_posts_size}"
	end
end
