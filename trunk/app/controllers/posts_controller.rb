class PostsController < ApplicationController
	before_filter :login_required, :except => [:index, :show, :search, :digg]
  # GET /posts
  # GET /posts.xml
  #before_filter :get_project
  
  def index
  	if @category_id = params[:category_id]
  		categories = [@category_id] + Category.find(@category_id).children.map(&:id)
	  	conditions = ['category_id IN (?)', categories]
  	end
  	order = 'created_at DESC'
  	order = [params[:sort], order].join(',') unless params[:sort].blank?

  	@categories = Category.all(:include => [:children])
    @posts = Post.paginate(:all, 
											 :per_page => 10, :page => params[:page],
    									 :conditions => conditions, :order => order)
  	@post_total = Post.count(:conditions => conditions)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def search
  	unless params[:q].blank?
			all_posts = Post.search(params[:q]) 
			@post_total = all_posts.size
			@posts = Post.paginate_search(params[:q], nil, 
																		:order => 'updated_at DESC', 
																		:page => params[:page], :per_page => 10) 
			@categories = Category.all_for(all_posts)
			render :action => 'index'
		else
			redirect_to :back
		end
	end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id], :include => :comments)
		@post.increment!(:read_count)		

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = current_user.posts.new(params[:post])
    #attachments = params[:post][:attachables]
  	#raise attachments.inspect
    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = current_user.posts.find(params[:id])
    @post.send("#{params[:event]}!") if params[:event]

    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to :back }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def digg
		@post = Post.find(params[:id])
		@post.digg! request.remote_addr, current_user
		redirect_to :back  	
	end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  def get_project
  	@project = params[:project]
  	@projects = Project.find(:all)
	end
  
end
