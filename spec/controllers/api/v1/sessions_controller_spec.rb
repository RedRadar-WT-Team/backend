require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let!(:user) { create(:user) }
  let(:header) { { 'Content-Type' => 'application/json', 'X-User-Id' => user.id.to_s } }

  describe 'POST #create' do
    context 'with valid email' do
      it 'logs in the user and stores email in session' do
        post api_v1_login_path params: { email: user.email }.to_json, headers: header

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(200)

        expect(json_response['message']).to eq('Logged in successfully')

        expect(session[:current_user_email]).to eq(user.email)
      end
    end

    context 'with invalid email' do
      it 'returns an error when the user is not found' do
        post api_v1_login_path, params: { email: 'nonexistent@example.com' }.to_json, headers: header
        json_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:not_found)
        expect(json_response[:error]).to eq('User not found')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'logs out the user and clears the session' do
      session[:current_user_email] = user.email

      delete api_v1_logout_path

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(session[:current_user_email]).to be_nil


      expect(response).to have_http_status(:ok)
      expect(json_response[:message]).to eq('Logged out successfully.')
    end
  end
end
#        Prefix Verb   URI Pattern              Controller#Action
#  api_v1_login POST   /api/v1/login(.:format)  api/v1/sessions#create
#  api_v1_logout DELETE /api/v1/logout(.:format) api/v1/sessions#destroy