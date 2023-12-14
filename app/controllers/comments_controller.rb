class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create update destroy vote]
  before_action :set_comment, only: %i[update destroy vote]
  before_action :set_post, only: %i[destroy create]

  def create
    @comment = current_user.comments.new(comment_params)
    respond_to do |format|
      if @comment.check_comment == true
        format.html { redirect_to post_path(params[:post_id]), alert: "Bad word found!!! 😓😓😓"}
      else
        ActiveRecord::Base.transaction do
          if @comment.save
            if params[:reply].present?
            #   do noti for comment's user
              message = "#{current_user.username} reply your comment in #{@post.title.truncate(10)}"
              create_notification_for_comment(@comment.parent,message)
            else
              if current_user != @comment.post.user
                message = "#{current_user.username} comment in your post #{@post.title.truncate(10)}"
                create_notification_for_post(@comment,@post,message)
              end
            end
            format.html { redirect_to post_path(params[:post_id]), notice: "Comment was successfully created." }
          else
            format.html { redirect_to post_path(params[:post_id]), alert: "Comment can't be blank! 😓😓😓"}
          end
        end
      end

    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html {
        flash[:notice] = 'Comment was successfully destroyed.'
        redirect_to post_path(@post)
      }
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

  def set_post
    @post = Post.find(params[:post_id])
  end

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

  def create_notification_for_post(comment,post,message)
    # Tạo Notification cho comment
    Notification.create(
      sender: current_user,
      receiver: post.user,
      object: comment,
      as_read: false,
      content: message
    )
  end

  def create_notification_for_comment(comment,message)
    # Tạo Notification cho comment
    Notification.create(
      sender: current_user,
      receiver: comment.user,
      object: comment,
      as_read: false,
      content: message
    )
  end
end
