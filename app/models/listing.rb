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
#  slug        :string
#  company_id  :integer
#

class Listing < ApplicationRecord
  belongs_to :category
  belongs_to :person
  belongs_to :company, class_name: "Designer", foreign_key: :company_id

  has_many :listings_sizes
  has_many :listings, through: :listings_sizes
  has_many :uploads

  has_one :address, as: :owner
  accepts_nested_attributes_for :address

  include Utilities
  attr_accessor :sizes

  validates_presence_of :description, :sizes

  CONDITIONS = [
    "1/10", "2/10", "3/10", "4/10", "5/10", "6/10", "7/10", "8/10", "9/10", "Deadstock"
  ]

  def has_address?
    address.present?
  end
end
