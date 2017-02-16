class CreateListingsSizes < ActiveRecord::Migration[5.0]
  def change
    create_table :listings_sizes do |t|
      t.integer :listing_id
      t.integer :size_id

      t.timestamps
    end
  end
end
