require 'rails_helper'

RSpec.describe EmpireFlippersService do
  describe ".fetch_listings" do
    it "returns an array of listings" do
      fake_response = {
        "data" => {
          "listings" => [
            {
              "listing_number" => 12345,
              "listing_price" => 50000,
              "summary" => "A great business",
              "listing_status" => "For Sale"
            }
          ]
        }
      }

      allow(HTTParty).to receive(:get).and_return(fake_response)

      result = EmpireFlippersService.fetch_listings

      expect(result).to be_an(Array)
      expect(result.first["listing_number"]).to eq(12345)
    end
  end
end