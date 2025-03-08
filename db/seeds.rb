# db/seeds.rb
# 
# require 'faker'

User.create!(email: "funtimes@consultancy.com", state: "Maryland", zip: "20879")

# User.delete_all

# 10.times do 
#   User.create( 
#     email: Faker::Internet.unique.email,
#     state: Faker::Address.state,
#     zip: Faker::Number.number(digits: 5) 
#   )
# end

# Faker::UniqueGenerator.clear