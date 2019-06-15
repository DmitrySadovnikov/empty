class CreateTransfers < ActiveRecord::Migration[5.2]
  def change
    create_table :transfers, id: :uuid do |t|
      t.belongs_to :user, null: false, type: :uuid, foreign_key: true
      t.integer :status, null: false
      t.jsonb :data, null: false, default: {}
      t.timestamps
    end
  end
end
