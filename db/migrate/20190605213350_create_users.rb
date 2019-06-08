class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false, unique: true
      t.timestamps
    end
  end
end
