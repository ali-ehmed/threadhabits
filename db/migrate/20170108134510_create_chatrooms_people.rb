class CreateChatroomsPeople < ActiveRecord::Migration[5.0]
  def change
    create_table :chatrooms_people do |t|
      t.references :chat_room, foreign_key: true
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
