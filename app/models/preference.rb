class Preference < ApplicationRecord
  belongs_to :person

  scope :notifications, -> { where("preference_type = 'Notification'") }

  def activated
    data.select do |key, value|
      value == "true"
    end.keys.map(&:to_sym)
  end
end
