# spec/factories/users.rb

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    state { Faker::Address.state }
    zip { Faker::Number.number(digits: 5) }
  end
end
