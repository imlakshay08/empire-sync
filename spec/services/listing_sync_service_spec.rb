require 'rails_helper'

RSpec.describe ListingSyncService do
  describe ".sync" do
    let(:fake_listings) do
      [{
        "listing_number" => 12345,
        "listing_price" => 50000,
        "summary" => "A great business",
        "listing_status" => "For Sale"
      }]
    end

    before do
      allow(EmpireFlippersService).to receive(:fetch_listings).and_return(fake_listings)
      allow(HubspotService).to receive(:create_deal).and_return("hs_deal_123")
      allow(GoogleSheetsService).to receive(:export)

    end

    it "syncs listings from Empire Flippers" do
      ListingSyncService.sync

      expect(Listing.count).to eq(1)
      expect(Listing.first.listing_number).to eq(12345)
      expect(Listing.first.listing_price).to eq(50000)
      expect(Listing.first.summary).to eq("A great business")
      expect(Listing.first.listing_status).to eq("For Sale")
    end

    it "does not create duplicate listings" do
      ListingSyncService.sync
      ListingSyncService.sync

      expect(Listing.count).to eq(1)
    end

    it "creates a hubspot deal for new listings" do
      ListingSyncService.sync

      expect(HubspotService).to have_received(:create_deal)
      expect(Listing.first.hubspot_deal_id).to eq("hs_deal_123")
    end

    it "does not create hubspot deal if one already exists" do
      ListingSyncService.sync
      allow(HubspotService).to receive(:create_deal)
      ListingSyncService.sync

      expect(HubspotService).to have_received(:create_deal).once
    end
  end
end