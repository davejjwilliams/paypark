class ConversationsController < ApplicationController

  def create
    @conversation = Conversation.get(current_user.id, params[:user_id])

    # Open the conversation, if it isn't already open
    add_to_conversations unless conversated?

    respond_to do |format|
      format.js
    end
  end

  def close
    @conversation = Conversation.find(params[:id])

    session[:conversations].delete(@conversation.id)

    respond_to do |format|
      format.js
    end
  end


  private

  def add_to_conversations
    session[:conversations] ||= []
    session[:conversations] << @conversation.id
  end

  # Check if the current conversation is open
  def conversated?
    session[:conversations].include?(@conversation.id)
  end

end
