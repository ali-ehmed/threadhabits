# == Schema Information
#
# Table name: addresses
#
#  id         :integer          not null, primary key
#  location   :string
#  latitude   :float
#  longitude  :float
#  place_id   :string
#  owner_type :string
#  owner_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
