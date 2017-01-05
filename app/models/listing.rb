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

class Listing < ApplicationRecord
  belongs_to :category
  belongs_to :person
  belongs_to :size
  belongs_to :company, class_name: "Designer", foreign_key: :company_id

  has_many :uploads, dependent: :destroy

  has_one :address, as: :owner
  accepts_nested_attributes_for :address

  has_attached_file :display_image, styles: { medium: "300x300#", large: "1024x1024#" }, :default_url => "/assets/profile-icon.png"
  validates_attachment_content_type :display_image, content_type: /\Aimage\/.*\Z/

  include Utilities

  attr_accessor :upload_photos

  validates_presence_of :description, :size

  %w(tops bottoms shoes accessories).each do |product|
    scope product.to_sym, -> { joins(:size => :product_type).where("lower(product_types.name) = ?", product) }
  end

  CONDITIONS = [
    "1/10", "2/10", "3/10", "4/10", "5/10", "6/10", "7/10", "8/10", "9/10", "Deadstock"
  ]

  def upload_photos=(files = [])
    self.display_image = files.first
    save!
    files.each{|file| (@upload_photos ||= []) << uploads.create(image: file) }
  end

  def has_address?
    address.present?
  end

  def self.fetch_by_filters(filters)
    listings = all
    conditions = []

    if filters[:category_ids]
      conditions << "category_id in (:categories)"
    end

    if (filters.keys & ["lower_price", "upper_price"]).length == 2
      conditions << "price >= #{filters[:lower_price]} AND price <= #{filters[:upper_price]}"
    end

    if filters[:product_type].present?
      listings = listings.send(filters[:product_type])
    end

    if filters[:company_ids]
      conditions << "company_id in (:companies)"
    end


    if filters[:size_names]
      listings = listings.joins(:size) unless filters[:product_type].present?
      conditions << "sizes.name in (:size_names)"
    end

    if filters[:location]
      listings = listings.joins(:address)
      conditions << "addresses.latitude in (:latitude) and addresses.longitude in (:longitude)"
    end

    if filters[:conditions]
      conditions << "condition in (:conditions})"
    end

    listings.where(conditions.join(" AND "), {
        size_names: filters[:size_names], companies: filters[:company_ids],
        categories: filters[:category_ids], condition: filters[:conditions],
        latitude: filters[:latitude], longitude: filters[:longitude],
      }
    )
  end
end
