ActiveAdmin.register Person do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :email, :username, :address, :first_name, :last_name
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  index do
    column :email
    column :username
    column :address
    column :first_name
    column :last_name
  end

  form do |f|
    f.input :email
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end
end
