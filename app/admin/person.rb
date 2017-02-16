ActiveAdmin.register Person, :as => "Users" do
  menu priority: 1
  permit_params :email, :username, :address, :first_name, :last_name

  index do
    column :email
    column :username
    column :address
    column :first_name
    column :last_name
    actions
  end
end
