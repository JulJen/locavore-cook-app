class CreateIngredients < ActiveRecord::Migration[5.2]
  def change
    create_table :ingredients do |t|
      t.string :name, limit: 20
      t.timestamp :created_at, null: false
      t.timestamp :updated_at, null: false
    end
  end
end
