class BlogsController < ApplicationController

  before_filter :scope_blog

  def archive
    @posts_by_month = @blog.posts_by_month
  end

  def feed
    @posts = @blog.posts.published
  end

  def search
    @posts = params[:keyword] ? @blog.search(params[:keyword]) : []
  end

  def show
    @posts = @blog.posts.page(params[:page]).published.per(@blog.posts_per_page)
    @topics = @blog.topics.roots if @blog.has_topics?
  end

  private

  def scope_blog
    @blog = Blog.first
  end

end
