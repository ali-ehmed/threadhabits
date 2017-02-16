# == Schema Information
#
# Table name: chatrooms_people
#
#  id           :integer          not null, primary key
#  chat_room_id :integer
#  person_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ChatroomsPerson < ApplicationRecord
  belongs_to :chat_room
  belongs_to :person
end
