class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.string :name, limit: 20
      t.string :content, limit: 60
      t.string :directions, limit: 250
      t.integer :user_id
      t.timestamp :created_at, null: false
      t.timestamp :updated_at, null: false
    end
  end
end
