class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.references :chat_room, foreign_key: true
      t.integer :sender_id
      t.integer :receiver_id
      t.text :body

      t.timestamps
    end
  end
end
