class Listing < ApplicationRecord
    validates :listing_number, presence: true, uniqueness: true
    validates :listing_price, presence: true
end
