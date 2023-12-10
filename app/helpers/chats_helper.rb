module ChatsHelper
  def list_name(chat)
    if chat.messages.any?
      chat.messages.first.content.truncate(20)
    else
      "New Chat #{chat.id}"
    end
  end
end
