class CommentsController < ApplicationController

  def create
    @comment = Comment.new(params[:comment])
    @comment.user_ip = request.remote_ip
    @comment.user_agent = request.env['HTTP_USER_AGENT']
    @comment.referrer = request.env['HTTP_REFERER']
    if @comment.save
      flash[:notice] = 'Your comment has been submitted for approval.'
      redirect_to @comment.post.full_path
    else
      render :action => 'new'
    end
  end

end
