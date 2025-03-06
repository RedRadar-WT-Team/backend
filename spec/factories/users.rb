# spec/factories/users.rb

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    state { Faker::Address.state }
    zipcode { Faker::Address.zip_code }
  end
end
