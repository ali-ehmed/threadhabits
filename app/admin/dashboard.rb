ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        span "Welcome to Threadhabits Admin Dashboard"
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "Recent Users Registered" do
          table_for Person.recent(5) do
            column :full_name
            column :username
            column :location
            column :account_confirmed_at do |p|
              I18n.l p.confirmed_at, format: :short_date rescue nil
            end
          end
          div(class: "view-all") {
            strong { link_to "View All Users", admin_users_path }
          }
        end
      end

      column do
        panel "Recent Listings" do
          table_for Listing.recent(5) do
            column :name
            column :person
            column :price
            column :location
            column :created_at do |l|
              I18n.l l.created_at, format: :short_date rescue nil
            end
          end
          div(class: "view-all") {
            strong { link_to "View All Listings", admin_listings_path }
          }
        end
      end
    end
  end # content
end
