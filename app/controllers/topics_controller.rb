class TopicsController < ApplicationController

  # CRUD ===========================================================================================

  def show
    @blog = Blog.first
    @topic = params[:subtopic_slug] ? Topic.find(params[:subtopic_slug]) : Topic.find(params[:topic_slug])
    @subtopics = @topic.root? ? @topic.children : []
    @posts = @topic.root? ? [] : @topic.posts.published.to_a
  end

  private

end
