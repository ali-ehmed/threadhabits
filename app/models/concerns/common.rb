module Common
  extend ActiveSupport::Concern

  included do
    scope :recent, -> (n) { limit(n) }
  end
end
