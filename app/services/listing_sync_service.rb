class ListingSyncService
    def self.sync
      listings = EmpireFlippersService.fetch_listings
  
      listings.each do |listing_data|
        listing = Listing.find_or_create_by(listing_number: listing_data["listing_number"]) do |l|
          l.listing_price = listing_data["listing_price"]
          l.summary = listing_data["summary"]
          l.listing_status = listing_data["listing_status"]
        end
  
        if listing.hubspot_deal_id.nil?
          deal_id = HubspotService.create_deal(listing)
          listing.update(hubspot_deal_id: deal_id)
        end
      end

      GoogleSheetsService.export(Listing.all)

    end
  end