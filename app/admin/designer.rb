ActiveAdmin.register Designer, { :sort_order => :name_asc } do
  menu :label => "Company/Designers"
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :name

  index do
    column :name, sortable: true
    actions
  end
end
