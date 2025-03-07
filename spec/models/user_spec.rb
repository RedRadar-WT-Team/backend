# bundle exec rspec spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:valid_attributes) { { email: 'user@example.com', state: 'CA', zip: '90001' } }
  let(:user) { User.new(valid_attributes) }

  # ----------------- Validations -----------------
  describe 'validations' do
    context 'when valid attributes are provided' do
      it 'is valid' do
        expect(user).to be_valid
      end
    end

    context 'when email is blank' do
      it 'is not valid without an email' do
        user.email = ''
        expect(user).to_not be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end

      it 'is not valid with an invalid email format' do
        user.email = 'invalidemail'
        expect(user).to_not be_valid
        expect(user.errors[:email]).to include("is not a valid email format")
      end
    end

    context 'when state is blank' do
      it 'is not valid without a state' do
        user.state = ''
        expect(user).to_not be_valid
        expect(user.errors[:state]).to include("can't be blank")
      end
    end

    context 'when zip is blank or invalid' do
      it 'is not valid without a zip' do
        user.zip = ''
        expect(user).to_not be_valid
        expect(user.errors[:zip]).to include("can't be blank")
      end

      it 'is not valid with an invalid zip code format' do
        user.zip = '1234'
        expect(user).to_not be_valid
        expect(user.errors[:zip]).to include("must be a valid 5-digit zip code")
      end
    end

    context 'when email is already taken' do
      it 'is not valid with a duplicate email' do
        User.create(valid_attributes)  # Create the first user
        duplicate_user = User.new(valid_attributes)  # Create the second user with the same email
        expect(duplicate_user).to_not be_valid
        expect(duplicate_user.errors[:email]).to include("has already been taken")
      end
    end
  end

  # ----------------- Associations -----------------
  describe 'associations' do
    it { should have_many(:executive_orders_users) }
    it { should have_many(:executive_orders).through(:executive_orders_users) }
  end

  # ----------------- Creating a User -----------------
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
