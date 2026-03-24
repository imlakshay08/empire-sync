require 'rails_helper'

RSpec.describe HubspotService do
  describe '.create_deal' do
    it 'returns the created deal id' do
      listing = instance_double(
        'Listing',
        listing_number: 12345,
        listing_price: 50000,
        summary: 'A great business'
      )

      fake_response = instance_double('Hubspot::Crm::Deals::BasicApi', id: 'deal_123')
      basic_api = double('basic_api')
      deals = double('deals', basic_api: basic_api)
      crm = double('crm', deals: deals)
      client = double('client', crm: crm)

      allow(Hubspot::Client).to receive(:new).and_return(client)
      allow(basic_api).to receive(:create).and_return(fake_response)

      deal_id = HubspotService.create_deal(listing)

      expect(deal_id).to eq('deal_123')
    end
  end
end