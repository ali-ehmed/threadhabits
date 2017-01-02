class AddSlugToListings < ActiveRecord::Migration[5.0]
  def change
    add_column :listings, :slug, :string
  end
end
