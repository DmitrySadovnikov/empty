class CreateTorrentFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :torrent_files, id: :uuid do |t|
      t.string :magnet, null: false
      t.integer :status, null: false
      t.integer :transmission_id

      t.timestamps
    end

    add_index :torrent_files, :transmission_id, unique: true
  end
end
