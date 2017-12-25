class Medium < ApplicationRecord
  validates :shortcode, presence: true, uniqueness: true
end
