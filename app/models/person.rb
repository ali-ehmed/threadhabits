# == Schema Information
#
# Table name: people
#
#  id                       :integer          not null, primary key
#  email                    :string           default(""), not null
#  encrypted_password       :string           default(""), not null
#  reset_password_token     :string
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer          default(0), not null
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :inet
#  last_sign_in_ip          :inet
#  first_name               :string
#  last_name                :string
#  username                 :string
#  confirmation_token       :string
#  confirmed_at             :datetime
#  confirmation_sent_at     :datetime
#  unconfirmed_email        :string
#  admin                    :boolean          default(FALSE)
#  about_you                :text
#  phone_number             :string
#  avatar_file_name         :string
#  avatar_content_type      :string
#  avatar_file_size         :integer
#  avatar_updated_at        :datetime
#  cover_image_file_name    :string
#  cover_image_content_type :string
#  cover_image_file_size    :integer
#  cover_image_updated_at   :datetime
#  paypal_id                :string
#  facebook_profile         :string
#  instagram_profile        :string
#  twitter_profile          :string
#

class Person < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable


  has_one :address, as: :owner
  accepts_nested_attributes_for :address

  has_many :preferences
  has_many :listings

  has_many :chatrooms_persons, dependent: :destroy
  has_many :chat_rooms, through: :chatrooms_persons

  has_many :messages, foreign_key: :sender_id
  has_many :sent_messages, class_name: "Message", foreign_key: :sender_id
  has_many :received_messages, class_name: "Message", foreign_key: :receiver_id

  has_many :followings, class_name: "Follow", foreign_key: :following_id
  has_many :followers, class_name: "Follow", foreign_key: :follower_id

  attr_accessor :terms, :login, :setting_tab

  after_create :generate_default_preferences

  validates_acceptance_of :terms
  validates_presence_of :first_name, :last_name, :username
  validates_presence_of :paypal_id, if: Proc.new{|person| person.setting_tab == "payments"}
  validates :username,
  :presence => true,
  :uniqueness => {
    :case_sensitive => false
  }

  scope :admins, -> { where(admin: true) }

  has_attached_file :avatar, styles: {
    medium: "300x300#",
    thumb: "100x100#"
  }

  has_attached_file :cover_image, styles: {
    medium: "851x315#"
  }, default_url: "#{S3_ASSET_PATH}/THbanner.png"

  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  validates_attachment_content_type :cover_image, content_type: /\Aimage\/.*\Z/

  def admin?
    admin == true
  end

  def has_address?
    address.present?
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def full_name
    [first_name, last_name].join(" ")
  end

  def location
    address.try(:location)
  end

  def tagged_username
    ["@", username].join
  end

  def has_image?(field_name)
    send(field_name).url != send(field_name).options[:default_url]
  end

  def valid_attribute?(attribute_name)
    self.valid?
    self.errors[attribute_name].blank?
  end

  def send_message(options)
    message = messages.build(options)
    message.save
  end

  def is_current_person?(person)
    self.id == person.id
  end

  def conversations(recepient, listing_id)
    if listing_id.blank?
      chat_rooms.joins(:persons).where("people.id = ? and listing_id is null", recepient)
    else
      chat_rooms.joins(:persons).where("people.id = ? and listing_id = ?", recepient, listing_id)
    end
  end

  def following_a_person(person_id)
    followings.find_by_follower_id(person_id)
  end

  def generate_default_preferences
    unless self.preferences.notifications.present?
      hash = {}
      Preference::DEFAULT_PREFERENCES.each do |pref|
        hash[pref.to_sym] = false
      end
      pref = preferences.notifications.build(preference_type: "Notification")
      pref.data = hash
      pref.save
    end
  end

  # Checkout paypal business email
  def is_seller?
    self.paypal_id.present?
  end
end
