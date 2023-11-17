class CommentsController < ApplicationController

  def create
    @comment = current_user.comments.new(comment_params)
    respond_to do |format|
      if @comment.save
        format.html { redirect_to post_path(params[:post_id]), notice: "Comment was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def like_comment
    @comment = Comment.find(params[:id])
    current_user.like_comment(@comment)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: private_stream_comment
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :parent_id).merge(post_id: params[:post_id])
  end

  def private_stream_comment
    private_target = "#{helpers.dom_id(@comment)} comment_private_likes"
    turbo_stream.replace(private_target,
                         partial: 'likes/private_button_comment',
                         locals:{
                           comment: @comment,
                           comment_like_status: current_user.liked_comment?(@comment)
                         })
  end
end
