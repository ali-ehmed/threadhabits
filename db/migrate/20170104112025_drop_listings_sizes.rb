class DropListingsSizes < ActiveRecord::Migration[5.0]
  def change
    drop_table :listings_sizes
  end
end
