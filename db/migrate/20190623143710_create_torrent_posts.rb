class CreateTorrentPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :torrent_posts, id: :uuid do |t|
      t.integer :provider, null: false
      t.string :outer_id, null: false
      t.string :magnet_link, null: false
      t.string :title, null: false
      t.string :body, null: false
      t.string :image_url
      t.bigint :torrent_size
      t.timestamps
    end

    add_index :torrent_posts, %i[outer_id provider], unique: true
  end
end
