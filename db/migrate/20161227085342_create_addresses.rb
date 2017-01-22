class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :location
      t.float :latitude
      t.float :longitude
      t.string :place_id
      t.string :owner_type
      t.integer :owner_id

      t.timestamps
    end
  end
end
