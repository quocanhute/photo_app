class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    role = @chat.messages.any? ? 'user' : 'system'
    @message = @chat.messages.create!(message_params.merge(role: role))

    OpenaiResponseJob.perform_later(@chat.id)

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
