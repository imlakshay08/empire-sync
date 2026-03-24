class CreateListings < ActiveRecord::Migration[7.1]
  def change
    create_table :listings do |t|
      t.integer :listing_number
      t.decimal :listing_price
      t.text :summary
      t.string :listing_status
      t.string :hubspot_deal_id

      t.timestamps
    end
  end
end
