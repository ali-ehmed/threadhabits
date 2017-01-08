class InboxController < ApplicationController
  before_action :authenticate_person!
  before_action :set_chat_rooms, only: [:index, :show]
  before_action :set_chat_room, only: [:show]

  def index
    @chat_room = current_person.chat_rooms.first
    @messages = @chat_room.messages.order("created_at asc")
    @messages.last.mark_as_read if @messages.last.receiver_id == current_person.id
    @message = Message.new
  end

  def show
    @messages = @chat_room.messages.order("created_at asc")
    @messages.last.mark_as_read if @messages.last.receiver_id == current_person.id
    @message = Message.new
  end

  def create
    @chatroom = ChatRoom.new(chatroom_params)
    ChatRoom.transaction do
      if @chatroom.save
        sender_id   = current_person.id
        receiver_id = @chatroom.messages.first.receiver_id

        [sender_id, receiver_id].each do |recepient|
          @chatroom.chatrooms_persons.create(person_id: recepient)
        end

        current_person.send_message({
          receiver_id: receiver_id,
          chat_room_id: @chatroom.id
        })

        render json: { status: 200, inbox_path: inbox_path(@chatroom) }
      else
        render json: { status: false }
      end
    end
  end

  private

  def set_chat_room
    begin
      @chat_room = current_person.chat_rooms.includes(:messages).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { redirect_to inbox_index_path, flash: { alert: "Chatroom could not found" } and return }
        format.json { render json: { status: 200, message: "Chatroom could not found" } and return }
      end
    end
  end

  def set_chat_rooms
    @chat_rooms = current_person.chat_rooms.includes(:messages).order("messages.created_at desc")
  end

  def chatroom_params
    params.require(:chat_room).permit(:title, :listing_id, :messages_attributes => [:id, :receiver_id, :sender_id, :body])
  end
end
