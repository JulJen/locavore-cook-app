require 'faker'

User.destroy_all
50.times do |index|
  User.create!(fname: Faker::Name.first_name, #=> "Kaci"
    lname: Faker::Name.last_name, #=> "Ernser"
    username: Faker::Internet.user_name(5..10), #=> "alexie"
    password_digest: Faker::Internet.password(10, 20, true, true), #=> "*%NkOnJsH4"
    email: Faker::Internet.email,  #=> "eliza@mann.net"
    state: Faker::Address.state_abbr, #=> "AP"
    bio: Faker::Lorem.sentence(3, true, 4)
  )
end


Recipe.destroy_all
50.times do |index|
  Recipe.create!(name: Faker::Food.dish, #=> "Caesar Salad"
    content: Faker::Lorem.sentence(3, true, 4), #=> "Accusantium tantillus dolorem
    directions: Faker::Food.description,  #=> "Three eggs with cilantro, tomatoes, onions, avocados and melted Emmental cheese. With a side of roasted potatoes, and your choice of toast or croissant."
    created_at: Faker::Date.between(4.months.ago, 1.month.ago),
    updated_at: Faker::Date.between(1.month.ago, Date.today)
  )
end


Ingredient.destroy_all
50.times do |index|
  Ingredient.create!(name: Faker::Food.ingredient)
end

RecipeIngredient.destroy_all
50.times do |index|
  RecipeIngredient.create!(name: Faker::Food.ingredient, #=> "Adzuki Beans"
    quantity: Faker::Food.measurement)
end

p "Created #{Recipe.count} recipes by #{User.count} users"
