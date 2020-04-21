class ChatController < ApplicationController
  def chat

    session[:conversations] ||= []

    @users = User.all.where.not(id: current_user)
    @conversations = Conversation.includes(:recipient, :messages).find(session[:conversations])
    

  end
end
