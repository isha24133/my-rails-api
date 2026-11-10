class CreateCafes < ActiveRecord::Migration[7.1]
  def change
    create_table :cafes do |t|
      t.string :name, null: false
      t.string :address
      t.decimal :latitude, precision: 10, scale: 7
      t.decimal :longitude, precision: 10, scale: 7
      t.string :tell_number
      t.boolean :parking
      t.boolean :credit_card
      t.boolean :cashless
      t.text :image
      t.timestamps
    end

    add_index :cafes, :name
  end
end