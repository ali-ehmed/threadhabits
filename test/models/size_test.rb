# == Schema Information
#
# Table name: sizes
#
#  id              :integer          not null, primary key
#  name            :string
#  product_type_id :integer
#  selection       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class SizeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
