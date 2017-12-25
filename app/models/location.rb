class Location < ApplicationRecord
   validates :city, presence: true, uniqueness: true
end
