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

class ListingsSize < ApplicationRecord
  belongs_to :listing
  belongs_to :size
end
