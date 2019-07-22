class CreateTorrentFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :torrent_files, id: :uuid do |t|
      t.string :value, null: false
      t.timestamps
    end
  end
end
