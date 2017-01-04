class AddSizeIdToListings < ActiveRecord::Migration[5.0]
  def self.up
    add_column :listings, :size, :string
    add_column :listings, :product_type, :string
  end

  def self.down
    remove_column :listings, :size
    remove_column :listings, :product_type
  end
end
