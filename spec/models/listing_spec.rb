require 'rails_helper'

RSpec.describe Listing, type: :model do
    it "is a valid listing number" do
        listing = Listing.new(listing_number: 12345, listing_price: 100000)
        expect(listing).to be_valid
    end

    it "is invalid without a listing number" do
        listing = Listing.new(listing_number: nil, listing_price: 100000)
        expect(listing).not_to be_valid
    end

    it "does not allow duplicate listing numbers" do
        Listing.create!(listing_number: 12345, listing_price: 100000)
        duplicate = Listing.new(listing_number: 12345, listing_price: 100000)
        expect(duplicate).not_to be_valid
    end

    it "is invalid without a listing price" do
        listing = Listing.new(listing_number: 12345, listing_price: nil)
        expect(listing).not_to be_valid
    end
end