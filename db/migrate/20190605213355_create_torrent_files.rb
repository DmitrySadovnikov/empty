class CreateTorrentFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :torrent_files, id: :uuid do |t|
      t.belongs_to :user, null: false, type: :uuid
      t.string :magnet_link, null: false
      t.integer :status, null: false
      t.integer :transmission_id, unique: true
      t.string :google_drive_id, unique: true
      t.string :name
      t.jsonb :data
      t.timestamps
    end
  end
end
