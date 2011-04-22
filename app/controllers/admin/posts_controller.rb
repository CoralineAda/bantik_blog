class Admin::PostsController < ApplicationController

  before_filter :authenticate_user! if Object.const_defined?('Devise')
  before_filter :scope_blog
  before_filter :scope_post, :only => [:destroy, :edit, :show, :update]

  # CRUD ===========================================================================================
  def index
    params[:labels] = {
      :humanize_path => 'URL',
      :topic_name    => 'Topic',
      :state         => 'Status',
      :updated_at    => 'Last Modified'
    }
    params[:by] ||= 'publication_date'; params[:dir] ||= 'desc'; params[:show] ||= 'published'
    @filters = Post::FILTERS
    @posts = @blog.posts.descending(params[:by]).send(params[:show]) if params[:dir] == 'desc'
    @posts = @blog.posts.ascending(params[:by]).send(params[:show]) if params[:dir] == 'asc'
    @posts = @posts.page(params[:page]).per(25)
  end

  def show
  end

  def new
    @post = @blog.posts.build
  end

  def create
    handle_date_time(params, :post, 'publication_date')
    @post = @blog.posts.build(params[:post])
    if @post.save
      @post.publish! if params[:post][:state] == 'published' && @post.publication_date.blank?
      flash[:notice] = 'Successfully created post.'
      redirect_to admin_blog_post_path(@blog, @post)
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if params[:commit] == 'Preview'
      @post = @blog.posts.new params[:post]
      render :action => 'preview', :layout => 'application'
    else
      handle_date_time(params, :post, 'publication_date')
      if @post.update_attributes(params[:post])
        @post.publish! if params[:commit] == "Publish"
        @post.unpublish! if params[:commit] == "Save as Draft"
        flash[:notice] = 'Successfully updated post.'
        redirect_to admin_blog_post_path(@blog, @post)
      else
        render :action => 'edit'
      end
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = 'Successfully destroyed post.'
    redirect_to admin_blog_posts_url(@blog)
  end

  private

  def handle_date_time(params, model, attr)
    if params[model] && params[model]["#{attr}(1i)"]
      year = params[model]["#{attr}(1i)"]
      month = params[model]["#{attr}(2i)"]
      day = params[model]["#{attr}(3i)"]
      params[model]["#{attr}"] = Date.parse("#{month}/#{day}/#{year}")
      params[model].delete("#{attr}(1i)")
      params[model].delete("#{attr}(2i)")
      params[model].delete("#{attr}(3i)")
    end
  end

  def scope_blog
    @blog = Blog.first
  end

  def scope_post
    @post = @blog.posts.find(params[:id])
  end

end
