require 'FFaker'

User.destroy_all
20.times do |index|
  User.create!(fname: FFaker::Name.unique.first_name, #=> "Kaci"
    lname: FFaker::Name.unique.last_name, #=> "Ernser"
    username: FFaker::Internet.unique.user_name, #=> "alexie"
    password_digest: FFaker::Internet.unique.password, #=> "*%NkOnJsH4"
    email: FFaker::Internet.unique.email,  #=> "eliza@mann.net"
    state: FFaker::AddressUS.state_abbr, #=> "AP"
    bio: FFaker::Lorem.phrase #=> "Accusantium tantillus dolorem"
  )
end


Recipe.destroy_all
20.times do |index|
  Recipe.create!(name: FFaker::Lorem.word, #=> "Caesar Salad"
    content: FFaker::Lorem.phrase, #=> "Accusantium tantillus dolorem"
    directions: FFaker::Lorem.phrases,  #=> "Three eggs with cilantro, tomatoes, onions, avocados and melted Emmental cheese. With a side of roasted potatoes, and your choice of toast or croissant."
    created_at: FFaker::Time.between(4.months.ago, 1.month.ago),
    updated_at: FFaker::Time.between(4.months.ago, 1.month.ago)
  )
end


Ingredient.destroy_all
20.times do |index|
  Ingredient.create!(name: FFaker::Food.unique.herb_or_spice)
end

RecipeIngredient.destroy_all
20.times do |index|
  RecipeIngredient.create!(name: FFaker::Food.unique.herb_or_spice, #=> "Adzuki Beans"
    quantity: FFaker::UnitEnglish.liquid_name)
end

p "Created #{Recipe.count} recipes by #{User.count} users"
