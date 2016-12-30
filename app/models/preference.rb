# == Schema Information
#
# Table name: preferences
#
#  id              :integer          not null, primary key
#  person_id       :integer
#  data            :hstore
#  preference_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Preference < ApplicationRecord
  belongs_to :person

  scope :notifications, -> { where("preference_type = 'Notification'") }

  def activated
    data.select do |key, value|
      value == "true"
    end.keys.map(&:to_sym)
  end
end
