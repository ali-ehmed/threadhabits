# == Schema Information
#
# Table name: uploads
#
#  id                 :integer          not null, primary key
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  listing_id         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Upload < ApplicationRecord
  belongs_to :listing

  has_attached_file :image, styles: { medium: "120x160#", large: "1200x1200>", banner: "950x505>" }, :default_url => "/assets/profile-icon.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
