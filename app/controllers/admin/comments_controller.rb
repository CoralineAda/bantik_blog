class Admin::CommentsController < ApplicationController

  before_filter :authenticate_user! if Object.const_defined?('Devise')
  before_filter :scope_blog
  before_filter :scope_comment, :only => [:approve, :destroy]

  # Custom =========================================================================================

  def approve
    @comment.approve!
    if params[:refresh]
      render :partial => 'row', :locals => {:comment => @comment}
    else
      flash[:notice] = "The comment has been approved."
      redirect_to admin_blog_comments_path(@blog) and return
    end
  end

  # CRUD ===========================================================================================

  def index
    params[:by] ||= 'created_at'; params[:dir] ||= 'desc'; params[:show] ||= 'pending'
    @filters = Comment::FILTERS
    @comments = @blog.comments.descending(params[:by]).send(params[:show]) if params[:dir] == 'desc'
    @comments = @blog.comments.ascending(params[:by]).send(params[:show]) if params[:dir] == 'asc'
    @comments = @comments.page(params[:page]).per(25)
  end

  def destroy
    @comment.destroy
    redirect_to admin_blog_comments_url(@blog)
  end

  private

  def scope_blog
    @blog = Blog.first
  end

  def scope_comment
    @comment ||= @blog.comments.find(params[:id])
  end

end
