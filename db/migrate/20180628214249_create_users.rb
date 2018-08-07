class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :fname, limit: 20
      t.string :lname, limit: 20
      t.string :username, limit: 10
      t.string :email
      t.string :password_digest, limit: 10
      t.string :state, limit: 2
      t.string :bio, limit: 20
      t.timestamp :created_at, null: false
      t.timestamp :updated_at, null: false
    end
  end
end
