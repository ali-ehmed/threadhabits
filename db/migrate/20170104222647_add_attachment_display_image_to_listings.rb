class AddAttachmentDisplayImageToListings < ActiveRecord::Migration
  def self.up
    change_table :listings do |t|
      t.attachment :display_image
    end
  end

  def self.down
    remove_attachment :listings, :display_image
  end
end
