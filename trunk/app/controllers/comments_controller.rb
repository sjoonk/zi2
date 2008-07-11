class CommentsController < ApplicationController
	before_filter :login_required

  def create
    @post = Post.find(params[:post_id])
		@comment = @post.comments.build(params[:comment])
		@comment.user = current_user
    respond_to do |format|
      if @comment.save
        flash[:notice] = 'Issue was successfully created.'
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  	
  end
end
