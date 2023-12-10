class OpenaiResponseJob < ApplicationJob
  queue_as :default

  def perform(chat_id)
    chat = Chat.find(chat_id)
    call_openai(chat)
    # Do something later
  end

  def call_openai(chat)
    message = chat.messages.create(role: 'assistant', content: '')

    OpenAI::Client.new.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages: chat.messages.map { |m| { role: m.role, content: m.content } },
        temperature: 0.7,
        top_p: 1,
        frequency_penalty: 0.0,
        presence_penalty: 0.6,
        stream: stream_proc(message)
      }
    )
  end

  def stream_proc(message)
    proc do |chunk, _bytesize|
      new_content = chunk.dig('choices', 0, 'delta', 'content')
      message.update(content: message.content + new_content) if new_content.present?
    end
  end
end
