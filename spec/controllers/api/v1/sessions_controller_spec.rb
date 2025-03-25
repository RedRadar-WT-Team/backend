# bundle exec rspec spec/controllers/api/v1/sessions_controller_spec.rb

require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  before(:each) do
    @user = User.create!(email: 'testuser@example.com', state: 'California', zip: '94101') 
  end

  describe 'POST #create' do
    context 'when user exists' do
      it 'logs the user in and returns a success message' do
        post :create, params: { email: 'testuser@example.com' }
        
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['message']).to eq('Logged in successfully')
        expect(session[:user_id]).to eq(@user.id)
      end
    end

    context 'when user does not exist' do
      it 'returns an error message' do
        post :create, params: { email: 'nonexistent@example.com' }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('User not found')
        expect(session[:user_id]).to be_nil
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is logged in' do
      it 'logs the user out and returns a success message' do
        # session[:user_id] = user.id

        delete :destroy

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Logged out successfully.')
        expect(session[:user_id]).to be_nil
      end
    end

    context 'when no user is logged in' do
      it 'still returns a success message but does not affect session' do
        delete :destroy

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Logged out successfully.')
        expect(session[:user_id]).to be_nil
      end
    end
  end
end
