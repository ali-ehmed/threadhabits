# == Schema Information
#
# Table name: listings
#
#  id           :integer          not null, primary key
#  name         :string
#  description  :string
#  category_id  :integer
#  person_id    :integer
#  price        :float
#  condition    :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  slug         :string
#  company_id   :integer
#  size         :string
#  product_type :string
#

require 'test_helper'

class ListingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
