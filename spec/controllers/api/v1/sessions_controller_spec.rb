# bundle exec rspec spec/controllers/api/v1/sessions_controller_spec.rb

require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let(:user) { create(:user, email: 'testuser@example.com', state: 'California', zip: '94101') }

  before do
    allow_any_instance_of(ApplicationController).to receive(:session).and_return({ user_id: user.id })
  end 

  describe 'POST #create' do
    context 'when user exists' do
      it 'logs the user in and returns a success message' do
        post '/api/v1/session', params: { email: 'testuser@example.com' }, as: :json
        binding.pry
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['message']).to eq('Logged in successfully')
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context 'when user does not exist' do
      it 'returns an error message' do
        post '/api/v1/session', params: { email: 'nonexistent@example.com' }, as: :json

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
        delete '/api/v1/session'

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Logged out successfully.')
        expect(session[:user_id]).to be_nil
      end
    end

    context 'when no user is logged in' do
      it 'still returns a success message but does not affect session' do
        delete post '/api/v1/session'

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Logged out successfully.')
        expect(session[:user_id]).to be_nil
      end
    end
  end
end
