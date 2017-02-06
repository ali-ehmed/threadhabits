ActiveAdmin.register Category, { :sort_order => :name_asc } do
  # menu parent: "Utilities", label: 'Main Categories'
  menu false
  # menu label: "Main Cateogries"
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :name
end
