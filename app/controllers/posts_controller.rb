class PostsController < ApplicationController

  before_filter :scope_blog
  helper_method :handle_date_time

  def show
    @post = @blog.posts.published.by_slug(params[:post_slug]).first
    @subtopic = @post.topic
    unless @subtopic.nil
      @topic = @subtopic.parent? ? @subtopic.parent : @subtopic
    end
    @comment = Comment.new(params[:comment])
  end

  private

  def scope_blog
    @blog = Blog.first
  end

end
