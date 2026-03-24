class EmpireFlippersService

    BASE_URL = "https://api.empireflippers.com/api/v1/listings/list"

    def self.fetch_listings
        response = HTTParty.get(BASE_URL, query: {
            listing_status: "For Sale",
            limit: 100
        })

        response["data"]["listings"]
    end
end