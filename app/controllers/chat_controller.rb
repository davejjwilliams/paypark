class ChatController < ApplicationController
  def chat

    session[:conversations] ||= []

    if !Homeowner.find_by_user_id(current_user.id).nil?
      @homeowner_conversations_with = Driver.all.where(:id => Booking.select(:driver_id).all.where(:homeowner_id => Homeowner.find_by_user_id(current_user.id).id, :complete => false))
    end
    @driver_conversations_with = Homeowner.all.where(:id => Booking.select(:homeowner_id).all.where(:driver_id => Driver.find_by_user_id(current_user.id).id, :complete => false))

    @users = User.all.where.not(id: current_user)
    @conversations = Conversation.includes(:recipient, :messages).find(session[:conversations])


  end
end
