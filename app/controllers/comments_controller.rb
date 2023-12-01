class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create update destroy vote]
  before_action :set_comment, only: %i[update destroy vote]

  def create
    @comment = current_user.comments.new(comment_params)
    respond_to do |format|
      if @comment.save
        format.html { redirect_to post_path(params[:post_id]), notice: "Comment was successfully created." }
      else
        format.html { redirect_to post_path(params[:post_id]), alert: "Comment can't be blank! 😓😓😓"}
      end
    end
  end

  def vote
    case params[:type]
    when 'upvote'
      @comment.upvote!(current_user)
    when 'downvote'
      @comment.downvote!(current_user)
    else
      return redirect_to request.url, alert: "No such vote type"
    end
    respond_to do |format|
      format.html do
        redirect_to @comment.post
      end
      format.turbo_stream do
        render turbo_stream: private_stream_comment
      end
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id).merge(post_id: params[:post_id])
  end

  def private_stream_comment
    private_target = "#{helpers.dom_id(@comment)} comment_private_likes"
    turbo_stream.replace(private_target,
                         partial: 'likes/private_button_comment',
                         locals:{
                           comment: @comment,
                           user: current_user
                         })
  end
end
