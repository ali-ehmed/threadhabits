# == Schema Information
#
# Table name: follows
#
#  id           :integer          not null, primary key
#  following_id :integer
#  follower_id  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Follow < ApplicationRecord
  belongs_to :follower, class_name: "Person", foreign_key: :follower_id
  belongs_to :following, class_name: "Person", foreign_key: :following_id
end
