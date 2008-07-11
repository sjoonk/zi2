class Post < ActiveRecord::Base
	belongs_to :category, :counter_cache => true #'posts_count'
	belongs_to :user
	has_many :attachments
	has_many :comments
	has_many :diggs, :dependent => :delete_all

	acts_as_ordered
 	acts_as_taggable
 
	#acts_as_indexed :fields => [:title, :content]
	searchable_by :title, :content

	attr_writer :uploaded_attachments
	
	acts_as_state_machine :initial => :'준비'
	state :'준비'
	state :'작업중'
	state :'완료'
	
	event :start do
	 	transitions :from => :'준비', :to => :'작업중'
	end
	
	event :finish do
	 	transitions :from => :'작업중', :to => :'완료'
	end
	
	event :revoke do
		transitions :from => :'작업중', :to => :'준비'
		transitions :from => :'완료', :to => :'작업중'		
	end

	def to_s
		title
	end
	
	def uploaded_attachments=(attachments)
		attachments.each do |attach|
			if attach && attach.size > 0
				attachment = Attachment.new
				attachment.uploaded_data = attach
				self.attachments << attachment
			end
		end
	end
	
	def digg!(ip, digger = nil)
		unless digged_by? ip, digger
			digg = Digg.new
			digg.user_id = digger.id if digger && !digger.id.nil?
			digg.ip = ip
			diggs << digg
			return true
		else
			return false
		end
	end

	def digged_by?(ip, digger = nil)
		if digger && !digger.id.nil?
			return diggs.count(:conditions => ['user_id = ? or ip = ?', digger.id, ip]) > 0
		else
			return diggs.count(:conditions => ['ip = ?', ip]) > 0
		end
	end
	
	#def digg_count
	#	diggs.count
	#end
	
	
end
