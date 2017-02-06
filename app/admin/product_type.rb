ActiveAdmin.register ProductType, { :sort_order => :name_asc } do
  menu parent: "Utilities"
  permit_params :name
end
