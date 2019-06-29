class CreateTorrentEntities < ActiveRecord::Migration[5.2]
  def change
    create_table :torrent_entities, id: :uuid do |t|
      t.belongs_to :transfer, null: false, type: :uuid, foreign_key: true
      t.belongs_to :torrent_post, null: false, type: :uuid, foreign_key: true
      t.integer :transmission_id, unique: true
      t.integer :status, null: false
      t.string :name
      t.jsonb :data, null: false, default: {}
      t.timestamps
    end
  end
end
