class CreateUserAuths < ActiveRecord::Migration[5.2]
  def change
    create_table :user_auths, id: :uuid do |t|
      t.belongs_to :user, null: false, type: :uuid
      t.integer :provider, null: false
      t.jsonb :data, null: false
      t.timestamps
    end
  end
end
