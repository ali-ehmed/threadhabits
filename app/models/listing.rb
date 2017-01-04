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

class Listing < ApplicationRecord
  belongs_to :category
  belongs_to :person
  belongs_to :company, class_name: "Designer", foreign_key: :company_id

  has_many :uploads, dependent: :destroy

  has_one :address, as: :owner
  accepts_nested_attributes_for :address

  include Utilities

  attr_accessor :upload_photos

  validates_presence_of :description, :size

  CONDITIONS = [
    "1/10", "2/10", "3/10", "4/10", "5/10", "6/10", "7/10", "8/10", "9/10", "Deadstock"
  ]

  def upload_photos=(files = [])
    files.each{|file| (@upload_photos ||= []) << uploads.create(image: file) }
  end

  def has_address?
    address.present?
  end

  def display_image
    uploads.first.image
  end
end
