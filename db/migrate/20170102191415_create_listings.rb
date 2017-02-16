class CreateListings < ActiveRecord::Migration[5.0]
  def change
    create_table :listings do |t|
      t.string :name
      t.string :description
      t.integer :category_id
      t.integer :person_id
      t.float :price
      t.string :condition

      t.timestamps
    end
  end
end
