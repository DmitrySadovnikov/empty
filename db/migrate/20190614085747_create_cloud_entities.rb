class CreateCloudEntities < ActiveRecord::Migration[5.2]
  def change
    create_table :cloud_entities, id: :uuid do |t|
      t.belongs_to :transfer, null: false, type: :uuid, foreign_key: true
      t.belongs_to :parent, class_name: 'CloudEntity', type: :uuid, optional: true
      t.integer :status, null: false
      t.string :file_path, null: false
      t.string :cloud_file_id, unique: true
      t.string :cloud_file_url
      t.string :mime_type
      t.jsonb :data, null: false, default: {}
      t.timestamps
    end
  end
end
