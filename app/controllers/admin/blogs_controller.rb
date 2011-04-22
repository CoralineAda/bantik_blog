class Admin::BlogsController < ApplicationController

  before_filter :authenticate_user! if Object.const_defined?('Devise')
  before_filter :scope_blog, :except => [:create]

  def index
  end

  def show
  end

  def new
  end

  def create
    @blog = Blog.new(params[:blog])
    if @blog.save
      flash[:notice] = 'Successfully set up the blog.'
      redirect_to admin_blog_path(@blog)
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @blog.update_attributes(params[:blog])
      flash[:notice] = 'Successfully modified the blog.'
      redirect_to admin_blog_path(@blog)
    else
      render :action => 'edit'
    end
  end

  private

  def scope_blog
    if params[:id]
      @blog = Blog.find(params[:id])
    else
      @blog = Blog.first || Blog.new
    end
  end

end
