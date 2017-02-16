# == Schema Information
#
# Table name: addresses
#
#  id         :integer          not null, primary key
#  location   :string
#  latitude   :float
#  longitude  :float
#  place_id   :string
#  owner_type :string
#  owner_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Address < ApplicationRecord
  belongs_to :owner, polymorphic: true
end
