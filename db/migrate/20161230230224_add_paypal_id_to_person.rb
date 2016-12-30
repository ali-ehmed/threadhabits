class AddPaypalIdToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :paypal_id, :string
  end
end
