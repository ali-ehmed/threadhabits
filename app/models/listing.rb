# == Schema Information
#
# Table name: listings
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  category_id :integer
#  person_id   :integer
#  price       :float
#  condition   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Listing < ApplicationRecord
  belongs_to :category
  belongs_to :person
  has_many :listings_sizes
  has_many :listings, through: :listings_sizes

  has_many :uploads
end
