# db/seeds.rb
# 
require 'faker'

# user1 = User.create!(email: "funtimes@wtf.com", state: "Canada", zip: "11111")
User.delete_all

10.times do 
  User.create( 
    email: Faker::Internet.unique.email,
    state: Faker::Address.state,
    zip: Faker::Number.number(digits: 5) 
  )
end

Faker::UniqueGenerator.clear