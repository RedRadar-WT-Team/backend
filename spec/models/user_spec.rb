# bundle exec rspec spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:valid_attributes) { { email: 'user@example.com', state: 'CA', zip: '90001' } }

  describe 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(valid_attributes)
      expect(user).to be_valid
    end

    it 'is not valid without an email' do
      user2 = User.new(email: '', state: 'CA', zip: '90001')
      expect(user2).to_not be_valid
      expect(user2.errors[:email]).to include("can't be blank")
    end

    it 'is not valid with an invalid email format' do
      user3 = User.new(email: 'invalidemail', state: 'CA', zip: '90001')
      expect(user3).to_not be_valid
      expect(user3.errors[:email]).to include("is not a valid email format")
    end

    it 'is not valid without a state' do
      user4 = User.new(email: 'user4@example.com', state: '', zip: '90001')
      expect(user4).to_not be_valid
      expect(user4.errors[:state]).to include("can't be blank")
    end

    it 'is not valid without a zip' do
      user5 = User.new(email: 'user5@example.com', state: 'CA', zip: '')
      expect(user5).to_not be_valid
      expect(user5.errors[:zip]).to include("can't be blank")
    end

    it 'is not valid with an invalid zip code format' do
      user6 = User.new(email: 'user6@example.com', state: 'CA', zip: '1234')
      expect(user6).to_not be_valid
      expect(user6.errors[:zip]).to include("must be a valid 5-digit zip code")
    end

    it 'is not valid with a duplicate email' do
      User.create(valid_attributes)
      user7 = User.new(valid_attributes)
      expect(user7).to_not be_valid
      expect(user7.errors[:email]).to include("has already been taken")
    end
  end

  describe 'creating a user' do
    it 'creates a user with valid attributes' do
      user = User.create(valid_attributes)
      expect(user).to be_persisted
      expect(user.email).to eq('user@example.com')
      expect(user.state).to eq('CA')
      expect(user.zip).to eq('90001')
    end
  end
end