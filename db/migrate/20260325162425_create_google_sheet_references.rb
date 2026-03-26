class CreateGoogleSheetReferences < ActiveRecord::Migration[7.1]
  def change
    create_table :google_sheet_references do |t|
      t.string :sheet_id

      t.timestamps
    end
  end
end
