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
    column :product_type
    actions do |resource|
      item "Detail", detail_listings_path(resource.slug, category_slug: resource.category.slug)
      item "Edit", edit_listings_path(resource.slug, category_slug: resource.category.slug)
    end
  end
end
