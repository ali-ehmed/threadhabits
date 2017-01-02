# == Schema Information
#
# Table name: listings_sizes
#
#  id         :integer          not null, primary key
#  listing_id :integer
#  size_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ListingsSizeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
