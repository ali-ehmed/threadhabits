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

require 'test_helper'

class ChatroomsPersonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
