class AddFieldsToPeoples < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :first_name, :string
    add_column :people, :last_name, :string
    add_column :people, :username, :string, index: true, unique: true
  end
end
