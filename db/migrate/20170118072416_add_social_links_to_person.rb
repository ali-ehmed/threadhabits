class AddSocialLinksToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :facebook_profile, :string
    add_column :people, :instagram_profile, :string
    add_column :people, :twitter_profile, :string
  end
end
