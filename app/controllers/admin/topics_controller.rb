class Admin::TopicsController < ApplicationController
  before_filter :authenticate_user! if Object.const_defined?('Devise')
  before_filter :scope_blog
  before_filter :scope_topic, :only => [:show, :edit, :update, :destroy]

  # Custom =========================================================================================

  def restructure
    if params[:promote] && params[:promote] != ""
      # Moving to root level
      _topic = @blog.topics.find(params[:promote].gsub('topic_',''))
      _topic.move_to_root
    elsif params[:topic_id] != "" && params[:subtopic_id] != ""
      # Moving to topic
      _parent = @blog.topics.find(params[:topic_id].gsub('topic_',''))
      if _parent.depth == 0
        _child = @blog.topics.find(params[:subtopic_id].gsub('topic_',''))
        _child.move_to_child_of(_parent.id)
      else
        flash[:notice] = "Topics may only be nested one level deep."
      end
    end
    @topics = @blog.topics.roots
    render :partial => '/admin/topics/tree'

  end

	def reorder
		order = params[:itemlist]
		order.each_with_index do |id, sort_order|
		  item = @blog.topics.find(id)
			item.update_attributes(:position => sort_order + 1)
		end
		render :text => ''
	end


  # CRUD ===========================================================================================
  def index
    @topics = @blog.topics.roots.order_by ScaffoldLogic.mongoid_sorter_from(params[:by], params[:dir])
  end

  def show
  end

  def new
    @topic = @blog.topics.new
  end

  def create
    @topic = @blog.topics.new(params[:topic])
    if @topic.save
      flash[:notice] = 'Successfully created topic.'
      redirect_to admin_blog_topics_path(@blog)
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @topic.update_attributes(params[:topic])
      flash[:notice] = 'Successfully updated topic.'
      redirect_to admin_blog_topics_path(@blog)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @topic.destroy
    flash[:notice] = 'Successfully destroyed topic.'
    redirect_to admin_blog_topics_path(@blog)
  end

  private

  def scope_blog
    @blog = Blog.first
  end

  def scope_topic
    @topic = @blog.topics.find(params[:id])
  end
end
