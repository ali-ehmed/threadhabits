# == Schema Information
#
# Table name: product_types
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProductType < ApplicationRecord
  has_many :sizes

  validates_presence_of :name
end
