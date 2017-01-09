# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  chat_room_id :integer
#  sender_id    :integer
#  receiver_id  :integer
#  body         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  read         :boolean          default(FALSE)
#

class Message < ApplicationRecord
  belongs_to :chat_room
  accepts_nested_attributes_for :chat_room

  belongs_to :sender, class_name: "Person", foreign_key: :sender_id
  belongs_to :receiver, class_name: "Person", foreign_key: :receiver_id

  validates_presence_of :body

  def chat_room_attributes=(attributes)
    if attributes['id'].present?
      self.chat_room = ChatRoom.find(attributes['id'])
    end
    super
  end

  def mark_as_read
    update_attribute(:read, true)
  end

  def has_read?
    read.present?
  end
end
