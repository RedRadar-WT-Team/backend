require 'faker'

# user1 = User.create!(email: "funtimes@wtf.com", state: "Canada", zip: "11111")

10.times do 
  User.create( 
    email: Faker::Internet.email,
    state: Faker::Address.state,
    zip: Faker::Number.number(digits: 5) 
  )
end