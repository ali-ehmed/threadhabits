# == Schema Information
#
# Table name: chat_rooms
#
#  id         :integer          not null, primary key
#  title      :string
#  listing_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ChatRoom < ApplicationRecord
  belongs_to :listing
  has_many :chatrooms_persons, dependent: :destroy
  has_many :persons, through: :chatrooms_persons

  has_many :messages, dependent: :destroy
  accepts_nested_attributes_for :messages
end
