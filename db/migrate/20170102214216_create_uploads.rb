class CreateUploads < ActiveRecord::Migration[5.0]
  def change
    create_table :uploads do |t|
      t.attachment :image
      t.integer :listing_id
      t.timestamps
    end
  end
end
