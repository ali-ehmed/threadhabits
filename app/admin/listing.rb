ActiveAdmin.register Listing do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters

  actions :index, :destroy
  index do
    column :name
    column :price
    column :uploads do |listing|
      listing.uploads.count
    end
    column :size
    column :company
    actions do |resource|
      item "View", detail_listings_path(resource.slug)
      item "Edit", edit_listings_path(resource.slug)
    end
  end
end
