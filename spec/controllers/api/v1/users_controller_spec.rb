# bundle exec rspec spec/controllers/api/v1/users_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:valid_attributes) { { email: 'user@example.com', state: 'CA', zip: '90001' } }
  let(:invalid_attributes) { { email: '', state: 'CA', zip: '90001' } }
  let(:updated_attributes) { { email: 'newemail@example.com', state: 'NY', zip: '10001' } }
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'when valid parameters are provided' do
      it 'creates a new user' do
        post :create, params: { user: valid_attributes }

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Account created successfully!')
        expect(json_response['user']['email']).to eq(valid_attributes[:email])
      end
    end

    context 'when invalid parameters are provided' do
      it 'returns an error and does not save user' do
        post :create, params: { user: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        error_message = JSON.parse(response.body)['errors']
        expect(error_message).to eq("Email can't be blank")
      end
    end
  end

  describe 'GET #show' do
    context 'when user is found by id' do
      it 'returns the user' do
        user = create(:user)
        session[:user_id] = user.id

        get :show

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:ok)

        expect(json_response[:data][:attributes][:email]).to eq(user.email)
      end
    end

    context 'when user is not found by id' do
      it 'returns an error message' do
        get :show, params: { id: 'nonexistent' }

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:not_found)
        expect(json_response[:error]).to eq('User not found')
      end
    end
  end

  describe 'PATCH #update' do
    context 'when valid parameters are provided' do
      it 'updates the user successfully' do
        session[:user_id] = user.id

        patch :update, params: { id: user.id, user: updated_attributes }

        user.reload

        json_response = JSON.parse(response.body)  

        expect(response).to have_http_status(:ok)
        expect(json_response['message']).to eq('Account updated successfully!')
        expect(json_response['data']['email']).to eq('newemail@example.com')
        expect(json_response['data']['state']).to eq('NY')
        expect(json_response['data']['zip']).to eq('10001')

        expect(user.email).to eq(updated_attributes[:email])
        expect(user.state).to eq(updated_attributes[:state])
        expect(user.zip).to eq(updated_attributes[:zip])
      end
    end

    context 'when invalid parameters are provided' do
      it 'returns an error message and does not update' do
        session[:user_id] = user.id
        patch :update, params: { id: user.id, user: invalid_attributes }
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to include("Email can't be blank")

        user.reload

        expect(user.email).not_to eq(invalid_attributes[:email])
        expect(user.state).not_to eq(invalid_attributes[:state])
        expect(user.zip).not_to eq(invalid_attributes[:zip])
      end
    end
  end
end
