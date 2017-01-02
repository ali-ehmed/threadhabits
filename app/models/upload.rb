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
end
