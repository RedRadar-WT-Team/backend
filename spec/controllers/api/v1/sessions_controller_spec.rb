# spec/controllers/api/v1/session_controller_spec.rb

require 'rails_helper'

RSpec.describe Api::V1::SessionController, type: :controller do
  # Updated user creation to include required fields
  let(:user) { create(:user, email: 'testuser@example.com', state: 'California', zip: '94101') }

  describe 'POST #create' do
    context 'when user exists' do
      it 'logs the user in and returns a success message' do
        post api_v1_session_path, params: { email: 'testuser@example.com' }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Logged in successfully')
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context 'when user does not exist' do
      it 'returns an error message' do
        post api_v1_session_path, params: { email: 'nonexistent@example.com' }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('User not found')
        expect(session[:current_user_id]).to be_nil
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is logged in' do
      before { session[:user_id] = user.id }

      it 'logs the user out and returns a success message' do
        delete api_v1_session_path

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Logged out successfully.')
        expect(session[:user_id]).to be_nil
      end
    end

    context 'when no user is logged in' do
      it 'still returns a success message but does not affect session' do
        delete api_v1_session_path

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Logged out successfully.')
        expect(session[:user_id]).to be_nil
      end
    end
  end
end
