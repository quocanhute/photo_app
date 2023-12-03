class Chat < ApplicationRecord
  belongs_to :user

  attr_accessor :message

  def message=(message)
    messages = [
      { 'role' => 'system', 'content' => message}
    ]

    q_and_a.each do |question, answer|
      messages << { 'role' => 'user', 'content' => question}
      messages << { 'role' => 'assistant', 'content' => answer}
    end
    messages << { 'role' => 'user', 'content' => message } if messages.size > 1

    response_raw = client.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages: messages,
        temperature: 0.7,
        top_p: 1,
        frequency_penalty: 0.0,
        presence_penalty: 0.6
      }
    )

    Rails.logger.debug response_raw
    response = JSON.parse(response_raw.to_json, object_class: OpenStruct)

    self.q_and_a << [message, response.choices[0].message.content]
  end

  private

  def client
    OpenAI::Client.new
  end
end
