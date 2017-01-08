class MessagesController < ApplicationController
  before_action :set_chat_room, only: [:create]
  def new
    @receiver = Person.find(params[:receiver_id])

    conversations = current_person.conversations(@receiver.id, params[:listing_id])

    if conversations.blank?
      @object = ChatRoom.new
      @object.messages.build

      if params[:listing_id].present?
        @object.listing_id = params[:listing_id]
      end
    else
      @chat_room = conversations.first
      @object = @chat_room.messages.build
    end

    respond_to do |format|
      format.js
    end
  end

  def create
    @message = Message.new messages_params
    @message.chat_room_id = @chat_room.id
    respond_to do |format|
      if @message.save
        format.html { redirect_to inbox_path(@chat_room), notice: "Message has been sent successfully" }
        format.json { render json: { status: 200, inbox_path: inbox_path(@chat_room) } }
      else
        format.html do
          @chat_rooms = current_person.chat_rooms.includes(:messages)
          @messages = @chat_room.messages
          flash[:alert] = "Please review errors"
          render 'inbox/show'
        end
        format.json { render json: { status: false } }
      end
    end
  end

  private

  def set_chat_room
    begin
      @chat_room = ChatRoom.find(params[:chatroom_id])
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { redirect_to inbox_index_path, flash: { alert: "Chat Room could not found" } and return }
        format.json { render json: { status: 200, message: "Chat Room could not found" } and return }
      end
    end
  end

  def messages_params
    params.require(:message).permit(:body, :receiver_id, :sender_id)
  end
end
