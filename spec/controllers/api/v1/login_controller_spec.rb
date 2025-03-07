require 'rails_helper'

RSpec.describe Api::V1::LoginController, type: :controller do
  let!(:user) { create(:user) }

  describe 'POST #create' do
    context 'with valid email' do
      it 'logs in the user and stores email in session' do
        post :create, params: { email: user.email }

        expect(session[:current_user_email]).to eq(user.email)
        
        expect(response).to redirect_to(user_profile_path)
      end
    end

    context 'with invalid email' do
      it 'returns an error when the user is not found' do
        post :create, params: { email: 'nonexistent@example.com' }

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:not_found)
        expect(json_response[:error]).to eq('User not found')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'logs out the user and clears the session' do
      session[:current_user_email] = user.email

      delete :destroy

      expect(session[:current_user_email]).to be_nil

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:ok)
      expect(json_response[:message]).to eq('Logged out successfully.')
    end
  end
end
