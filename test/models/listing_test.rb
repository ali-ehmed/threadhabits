# == Schema Information
#
# Table name: listings
#
#  id                         :integer          not null, primary key
#  name                       :string
#  description                :string
#  category_id                :integer
#  person_id                  :integer
#  price                      :float
#  condition                  :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  slug                       :string
#  company_id                 :integer
#  size_id                    :integer
#  product_type_id            :integer
#  display_image_file_name    :string
#  display_image_content_type :string
#  display_image_file_size    :integer
#  display_image_updated_at   :datetime
#

require 'test_helper'

class ListingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
