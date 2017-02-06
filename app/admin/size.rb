ActiveAdmin.register Size, { :sort_order => :name_asc } do
  menu parent: "Utilities"
  permit_params :name, :product_type_id

  index do
    selectable_column
    column :id
    column :name
    column :product_type_id
    actions
  end
end
