class MessagesController < ApplicationController
  before_action :set_chat_room, only: [:create]
  def new
    @receiver = Person.find(params[:receiver_id])

    conversations = current_person.conversations(@receiver.id, params[:listing_id])

    if conversations.blank?
      @message = current_person.messages.build
      @chat_room = @message.build_chat_room

      if params[:listing_id].present?
        @chat_room.listing_id = params[:listing_id]
      end

      [current_person, @receiver].each do |recipient|
        @chat_room.chatrooms_persons.build(person_id: recipient.id)
      end
    else
      @chat_room = conversations.first
      @message = @chat_room.messages.build
    end

    respond_to do |format|
      format.js
    end
  end

  def create
    @message = Message.new messages_params

    Message.transaction do
      respond_to do |format|
        if @message.save
          format.html { redirect_to inbox_path(@message.chat_room), notice: "Message has been sent successfully" }
          format.json { render json: { status: 200, inbox_path: inbox_path(@message.chat_room) } }
        else
          format.html do
            @chat_rooms = current_person.chat_rooms.includes(:messages)
            @messages = @message.chat_room.messages
            flash[:alert] = "Please review errors"
            render 'inbox/show'
          end
          format.json { render json: { status: false } }
        end
      end
    end
  end

  private

  def set_chat_room
    begin
      @chat_room = ChatRoom.find(messages_params[:chat_room_attributes][:id])
    rescue ActiveRecord::RecordNotFound
      @chat_room = nil
    end
  end

  def messages_params
    params.require(:message).permit(:id, :body, :receiver_id, :sender_id, :chat_room_attributes => [:id, :listing_id, :_destroy, :chatrooms_persons_attributes => [:id, :person_id, :chat_room_id, :_destroy]])
  end
end
