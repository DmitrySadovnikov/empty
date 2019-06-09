class CreateTorrentEntities < ActiveRecord::Migration[5.2]
  def change
    create_table :torrent_entities, id: :uuid do |t|
      t.belongs_to :user, null: false, type: :uuid
      t.string :magnet_link, null: false
      t.integer :status, null: false
      t.string :name
      t.integer :transmission_id, unique: true
      t.string :google_drive_id, unique: true
      t.string :google_drive_view_link
      t.jsonb :data, null: false, default: {}
      t.timestamps
    end
  end
end
