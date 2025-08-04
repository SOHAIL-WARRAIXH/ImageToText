Rails.application.routes.draw do
  root "home#index"

  get "chat", to: "chat#index", as: "chat_index"
  get "chat/:id", to: "chat#show", as: "chat_show"
  post "chat/:conversation_id/messages", to: "chat#create_message", as: "create_message"
  post "chat/new", to: "chat#new_conversation", as: "new_conversation"
  patch "chat/:id/update", to: "chat#update_conversation", as: "update_conversation"
  delete "chat/:id/delete", to: "chat#delete_conversation", as: "delete_conversation"
  get "download_image", to: "chat#download_image", as: "download_image"
end
