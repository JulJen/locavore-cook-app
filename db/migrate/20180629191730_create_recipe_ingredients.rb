class CreateRecipeIngredients < ActiveRecord::Migration[5.2]
  def change
    create_table :recipe_ingredients do |t|
      t.string :name, limit: 20
      t.string :quantity, limit: 20
      t.integer :ingredient_id
      t.integer :recipe_id
    end
  end
end
