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
        expect(response.body).to include('Account created successfully!')
      end
    end

    context 'when invalid parameters are provided' do
      let(:no_email) { { email: '', state: 'CA', zip: '90001' } }
      let(:no_zip) { { email: 'test@example.com', state: 'CA', zip: '' } }

      it 'throws error when no email is provided' do
        post :create, params: { user: no_email }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Email can't be blank")
      end

      it 'throws error when no zip is provided' do
        post :create, params: { user: no_zip }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Zip can't be blank")
      end
    end
  end
end
