class CategoriesController < ApplicationController

  def index
    @categories = Category.find(:all)
  end

  def show
    @category = Category.find(params[:id])
		index
		render :action => 'index'
  end

  def create
    @category = Category.create(params[:category])
		redirect_to @category
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      flash[:notice] = 'Category was successfully updated.'
    end
    redirect_to(@category)
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    flash[:notice] = "\"#{@category.name}\" 카테고리가 삭제되었습니다."
		redirect_to(categories_url) 
  end
end
