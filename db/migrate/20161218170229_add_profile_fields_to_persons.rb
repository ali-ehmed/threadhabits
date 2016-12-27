class AddProfileFieldsToPersons < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :about_you, :text
    add_column :people, :phone_number, :string
  end
end
