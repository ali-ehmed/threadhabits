class AddSizeIdToListings < ActiveRecord::Migration[5.0]
  def self.up
    add_column :listings, :size_id, :integer
    add_column :listings, :product_type_id, :integer
  end

  def self.down
    remove_column :listings, :size_id
    remove_column :listings, :product_type_id
  end
end
