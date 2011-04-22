class CommentsController < ApplicationController

  def create
    @comment = Comment.new(params[:comment])
    if @comment.save
      flash[:notice] = 'Your comment has been submitted for approval.'
      redirect_to @comment.post.full_path
    else
      render :action => 'new'
    end
  end

end
