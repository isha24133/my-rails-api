class CreateWantCafes < ActiveRecord::Migration[7.1]
  def change
    create_table :want_cafes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :cafe, null: false, foreign_key: true
      t.timestamps
    end

    add_index :want_cafes, %i[user_id cafe_id], unique: true
  end
end