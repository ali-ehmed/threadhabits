module Common
  extend ActiveSupport::Concern

  included do
    scope :recent, -> (n) { limit(n).order("created_at desc") }
  end
end
