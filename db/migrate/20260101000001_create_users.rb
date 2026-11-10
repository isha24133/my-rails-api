class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :mail, null: false
      t.string :password_digest, null: false
      t.text :profile_image
      t.string :api_token
      t.timestamps
    end

    add_index :users, :mail, unique: true
    add_index :users, :api_token, unique: true
  end
end