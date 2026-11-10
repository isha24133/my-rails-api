class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :cafe, null: false, foreign_key: true
      t.date :visit_date
      t.text :content, null: false
      t.text :image
      t.boolean :visibility, null: false, default: true
      t.timestamps
    end

    add_index :posts, %i[cafe_id created_at]
  end
end