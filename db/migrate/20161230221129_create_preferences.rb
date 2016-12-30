class CreatePreferences < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :preferences do |t|
      t.references :person, foreign_key: true
      t.hstore :data
      t.string :preference_type

      t.timestamps
    end
  end
end
