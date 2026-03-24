class AddUniqueIndexToListings < ActiveRecord::Migration[7.1]
  def change
    add_index :listings, :listing_number, unique: true
  end
end
