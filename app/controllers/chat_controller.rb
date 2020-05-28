class ChatController < ApplicationController
  before_action :authenticate_user!

  def chat

    session[:conversations] ||= []

    # Get the drivers which have booked with the current user, provided that the current user is a homeowner
    if !Homeowner.find_by_user_id(current_user.id).nil?
      @homeowner_conversations_with = User.all.where(:id => Driver.select(:user_id).all.where(:id => Booking.select(:driver_id).all.where(:homeowner_id => Homeowner.find_by_user_id(current_user.id).id, :complete => false)))
    end

    # Get the homeowners which the current user has booked with, provided that the current user is a driver
    if !Driver.find_by_user_id(current_user.id).nil?
      @driver_conversations_with = User.all.where(:id => Homeowner.select(:user_id).all.where(:id => Booking.select(:homeowner_id).all.where(:driver_id => Driver.find_by_user_id(current_user.id).id, :complete => false)))
    end

    if !Driver.find_by_user_id(current_user.id).nil?
      @driver_conversations_with = User.all.where(:id => Homeowner.select(:user_id).all.where(:id => Booking.select(:homeowner_id).all.where(:driver_id => Driver.find_by_user_id(current_user.id).id, :complete => false)))
    end
    
    @users = User.all.where.not(id: current_user)
    @conversations = Conversation.includes(:recipient, :messages).find(session[:conversations])

  end
end
