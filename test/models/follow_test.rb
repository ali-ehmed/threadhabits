# == Schema Information
#
# Table name: follows
#
#  id           :integer          not null, primary key
#  following_id :integer
#  follower_id  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class FollowTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
