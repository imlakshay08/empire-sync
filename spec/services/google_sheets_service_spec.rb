require 'rails_helper'

RSpec.describe GoogleSheetsService do
  let(:service) { GoogleSheetsService.new }
  let(:listings) do
    [
      instance_double('Listing',
        listing_number: 12345,
        listing_price: 50000,
        summary: 'A great business'
      )
    ]
  end

  let(:fake_client) { double('sheets_client') }
  let(:fake_spreadsheet) { double('spreadsheet', spreadsheet_id: 'sheet_abc') }

  before do
    allow(service).to receive(:client).and_return(fake_client)
  end

  describe '#export' do
  context 'when no sheet exists yet' do
    before do
      allow(ENV).to receive(:[]).with('GOOGLE_SHEET_ID').and_return('sheet_abc')
      allow(ENV).to receive(:[]).with('HUBSPOT_ACCESS_TOKEN').and_return('fake_token')
      allow(fake_client).to receive(:create_spreadsheet).and_return(fake_spreadsheet)
      allow(fake_client).to receive(:clear_values)
      allow(fake_client).to receive(:update_spreadsheet_value)
    end

    it 'creates a new sheet and stores the reference' do
      service.export(listings)
      expect(GoogleSheetReference.count).to eq(1)
      expect(GoogleSheetReference.first.sheet_id).to eq('sheet_abc')
    end
  end

  it 'writes header + listing rows' do
    GoogleSheetReference.create!(sheet_id: 'existing_sheet')
    allow(fake_client).to receive(:clear_values)
    
    expect(fake_client).to receive(:update_spreadsheet_value) do |sheet_id, range, value_range, _opts|
      expect(value_range.values.first).to eq(['Listing #', 'Listing Price', 'Summary'])
      expect(value_range.values[1]).to eq(['12345', '50000', 'A great business'])
    end
    
    service.export(listings)
  end

  context 'when sheet already exists' do
    before do
      GoogleSheetReference.create!(sheet_id: 'existing_sheet')
      allow(fake_client).to receive(:clear_values)
      allow(fake_client).to receive(:update_spreadsheet_value)
    end

    it 'reuses the existing sheet and does not create a new one' do
      expect(fake_client).not_to receive(:create_spreadsheet)
      service.export(listings)
    end

    it 'clears the sheet before writing' do
      expect(fake_client).to receive(:clear_values).with('existing_sheet', 'Sheet1')
      service.export(listings)
    end
   end
  end
end