require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    user = User.new(email: 'user@example.com', state: 'CA', zip: '90001')
    expect(user).to be_valid
  end

  it 'is invalid without an email' do
    user = User.new(state: 'CA', zip: '90001')
    user.valid? 
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'is invalid without a state' do
    user = User.new(email: 'user@example.com', zip: '90001')
    user.valid?
    expect(user.errors[:state]).to include("can't be blank")
  end

  it 'is invalid without a zip code' do
    user = User.new(email: 'user@example.com', state: 'CA')
    user.valid?
    expect(user.errors[:zip]).to include("can't be blank")
  end

  it 'is invalid with an invalid email format' do
    user = User.new(email: 'invalid_email', state: 'CA', zip: '90001')
    user.valid?
    expect(user.errors[:email]).to include('is invalid')
  end
end
