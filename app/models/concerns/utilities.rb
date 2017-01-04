module Utilities
  extend ActiveSupport::Concern

  included do
    validates_presence_of :name
    before_save :generate_slug
  end


  def generate_slug
    self.slug = name.parameterize
  end
end
