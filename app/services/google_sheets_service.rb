require 'google/apis/sheets_v4'
require 'googleauth'

class GoogleSheetsService
    SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS
    SPREADSHEET_TITLE = 'Empire Flippers Listings'
    def self.export(listings)
        new.export(listings)
      end
    
      def export(listings)
        sheet_id = find_or_create_sheet
        clear_sheet(sheet_id)
       write_rows(sheet_id, listings)
      end
    
      private
    
      def client
        @client ||= begin
          service = Google::Apis::SheetsV4::SheetsService.new
          service.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
            json_key_io: File.open(ENV['GOOGLE_SHEETS_CREDENTIALS_PATH']),
            scope: SCOPE
          )
          service
        end
      end
    
      def find_or_create_sheet
        sheet_id = GoogleSheetReference.first&.sheet_id
      
        if sheet_id.nil?
          sheet_id = ENV['GOOGLE_SHEET_ID']
          GoogleSheetReference.create!(sheet_id: sheet_id)
        end
      
        sheet_id
      end

      def clear_sheet(sheet_id)
        client.clear_values(sheet_id, 'Sheet1')
      end

      def write_rows(sheet_id, listings)
        values = [["Listing #", "Listing Price", "Summary"]]
        
        listings.each do |listing|
          values << [
            listing.listing_number.to_s,
            listing.listing_price.to_s,
            listing.summary
          ]
        end
      
        value_range = Google::Apis::SheetsV4::ValueRange.new(values: values)
        
        client.update_spreadsheet_value(
          sheet_id,
          'Sheet1',
          value_range,
          value_input_option: 'RAW'
        )
      end
end