class AddCompanyIdToListing < ActiveRecord::Migration[5.0]
  def change
    add_column :listings, :company_id, :integer
  end
end
