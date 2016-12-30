class AddAttachmentCoverImageToPeople < ActiveRecord::Migration
  def self.up
    change_table :people do |t|
      t.attachment :cover_image
    end
  end

  def self.down
    remove_attachment :people, :cover_image
  end
end
