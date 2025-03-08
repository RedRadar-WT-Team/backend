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

        # Use the `id` instead of `email`
        get :show, params: { id: user.id }

        json_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:ok)
        expect(json_response[:data][:id]).to eq(user.id.to_s)
      end
    end

    context 'when user is not found by id' do
      it 'returns an error message' do
        get :show, params: { id: 'nonexistent_id' }

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:not_found)
        expect(json_response[:error]).to eq('User not found')
      end
    end
  end

  describe 'PATCH #update' do
  context 'when valid parameters are provided' do
    before do
      @user = create(:user)
      session[:current_user_email] = @user.email
    end

    it 'updates the user successfully' do
      patch :update, params: { id: @user.id, user: updated_attributes }

      json_response = JSON.parse(response.body)  # Make sure to parse the response

      expect(response).to have_http_status(:ok)
      expect(json_response['message']).to eq('Account updated successfully!')
      expect(json_response['data']['email']).to eq(updated_attributes[:email])
      expect(json_response['data']['state']).to eq(updated_attributes[:state])
      expect(json_response['data']['zip']).to eq(updated_attributes[:zip])
    end
  end
end

  describe 'GET #by_email' do
    context 'when user exists for the given email' do
      it 'returns the user data' do
        request.headers['X-User-Email'] = user.email
        get :by_email

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['email']).to eq(user.email)
      end
    end

    context 'when user does not exist for the given email' do
      it 'returns an error message' do
        request.headers['X-User-Email'] = 'nonexistent@email.com'
        get :by_email

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('User not found')
      end
    end
  end
end