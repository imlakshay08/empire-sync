class HubspotService
    def self.create_deal(listing)
      client = Hubspot::Client.new(
        access_token: ENV['HUBSPOT_ACCESS_TOKEN'],
        ssl_options: { verify: false }
      )
  
      properties = {
        dealname: "Listing ##{listing.listing_number}",
        amount: listing.listing_price.to_s,
        closedate: (Time.now + 30.days).strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
        description: listing.summary
      }
  
      response = client.crm.deals.basic_api.create(
        simple_public_object_input_for_create: { properties: properties }
        )
  
      response.id
    end
  end