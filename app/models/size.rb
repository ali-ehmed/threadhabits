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

class Size < ApplicationRecord
  belongs_to :product_type

  has_many :listings

  scope :product, -> (name) { joins(:product_type).where "lower(products.name) = ?",  name.downcase}

  %w(tops bottoms shoes accessories).each do |product|
    scope product.to_sym, -> { joins(:product_type).where "lower(product_types.name) = ?",  product}
  end
end
