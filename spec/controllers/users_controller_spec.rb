# spec/controllers/users_controller_spec.rb
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #create' do
    context 'when valid parameters are provided' do
      let(:valid_attributes) { { email: 'user@example.com', state: 'CA', zip: '90001' } }

      it 'creates a new user' do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it 'returns a success message with status code 201' do
        post :create, params: { user: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.body).to include('Account created successfully!')
      end
    end

    context 'when invalid parameters are provided' do
      let(:invalid_attributes) { { email: '', state: 'CA', zip: '90001' } }

      it 'does not create a new user' do
        expect {
          post :create, params: { user: invalid_attributes }
        }.to_not change(User, :count)
      end

      it 'returns an error message with status code 422' do
        post :create, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Email can't be blank")
      end
    end
  end
end
