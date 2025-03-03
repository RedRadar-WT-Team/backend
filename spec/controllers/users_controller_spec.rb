# bundle exec rspec spec/controllers/users_controller_spec.rb
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #create' do
    context 'when valid parameters are provided' do
      let(:valid_attributes) { { email: 'user@example.com', state: 'CA', zip: '90001' } }

      it 'creates a new user' do
        post :create, params: { user: valid_attributes }

        created_user = User.last

        expect(response).to be_successful
        expect(created_user.email).to eq(valid_attributes[:email])
        expect(created_user.state).to eq(valid_attributes[:state])
        expect(created_user.zip).to eq(valid_attributes[:zip])
      end

      it 'returns a success message' do
        post :create, params: { user: valid_attributes }

        expect(response).to have_http_status(:created)
        message = JSON.parse(response.body)['message']
        expect(message).to eq('Account created successfully!')
      end
    end

    context 'when invalid parameters are provided' do
      let(:no_email) { { state: 'CA', zip: '90001' } }
      let(:no_state) { { email: 'anothertest@example.com', zip: '90001' } }
      let(:no_zip) { { email: 'test@example.com', state: 'CA' } }
      let(:invalid_email) { { email: 'invalidemail', state: 'CA', zip: '90001' } }
      let(:duplicate_email) { { email: 'user@example.com', state: 'CA', zip: '90001' } }
      let(:invalid_zip) { { email: 'newuser@example.com', state: 'CA', zip: '9D3F' } }

      it 'throws error when no email is provided' do
        post :create, params: { user: no_email }

        expect(response).to have_http_status(:unprocessable_entity)

        error_message = JSON.parse(response.body)['errors']
  
        expect(error_message).to eq("Email can't be blank")
      end

      it 'throws error when email format is invalid' do
        post :create, params: { user: invalid_email }

        expect(response).to have_http_status(:unprocessable_entity)

        error_message = JSON.parse(response.body)['errors']
        
        expect(error_message).to eq("Email is not a valid email format")
      end

      it 'throws error when email is already taken' do
        User.create(email: 'user@example.com', state: 'CA', zip: '90001')

        post :create, params: { user: duplicate_email }

        expect(response).to have_http_status(:unprocessable_entity)

        error_message = JSON.parse(response.body)['errors']
        expect(error_message).to eq("Email has already been taken")
      end

      it 'throws error when no state is provided' do
        post :create, params: { user: no_state }

        expect(response).to have_http_status(:unprocessable_entity)

        error_message = JSON.parse(response.body)['errors']
  
        expect(error_message).to eq("State can't be blank")
      end

      it 'throws error when no zip is provided' do
        post :create, params: { user: no_zip }

        expect(response).to have_http_status(:unprocessable_entity)

        error_message = JSON.parse(response.body)['errors']

        expect(error_message).to eq("Zip can't be blank")
      end

      it 'throws error when invalid zip is provided' do
        post :create, params: { user: invalid_zip }

        expect(response).to have_http_status(:unprocessable_entity)

        error_message = JSON.parse(response.body)['errors']

        expect(error_message).to eq("Zip must be a valid 5-digit zip code")
      end
    end
  end
end
