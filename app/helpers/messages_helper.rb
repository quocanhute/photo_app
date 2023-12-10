module MessagesHelper
  def icon_for(message)
    case message.role
    when 'system'
      '<i class="fa-solid fa-star"></i>'
    when 'user'
      '<i class="fa-solid fa-user"></i>'
    when 'assistant'
      '<i class="fa-solid fa-microchip"></i>'
    end
  end
end
