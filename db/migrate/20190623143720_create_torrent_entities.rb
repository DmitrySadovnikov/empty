class CreateTorrentEntities < ActiveRecord::Migration[5.2]
  def change
    create_table :torrent_entities, id: :uuid do |t|
      t.belongs_to :transfer, null: false, type: :uuid, foreign_key: true
      t.belongs_to :torrent_post, type: :uuid, foreign_key: true
      t.belongs_to :torrent_file, type: :uuid, foreign_key: true
      t.string :magnet_link
      t.integer :trigger, null: false
      t.integer :transmission_id, unique: true
      t.integer :status, null: false
      t.string :name
      t.jsonb :data, null: false, default: {}
      t.timestamps
    end
  end
end
