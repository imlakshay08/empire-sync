class EmpireFlippersService
    BASE_URL = "https://api.empireflippers.com/api/v1/listings/list"
  
    def self.fetch_listings
      listings = []
      page = 1
  
      loop do
        response = HTTParty.get(BASE_URL, query: {
          listing_status: "For Sale",
          limit: 100,
          page: page
        })
  
        raise "Empire Flippers API error: #{response.code}" unless response.success?
  
        page_listings = response["data"]["listings"]
        break if page_listings.empty?
  
        listings.concat(page_listings)
        page += 1
      end
  
      listings
    rescue StandardError => e
      Rails.logger.error "Failed to fetch EF listings: #{e.message}"
      raise
    end
  end