# bundle exec rspec spec/controllers/api/v1/sessions_controller_spec.rb

require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let(:user) { create(:user) }

  before do
    session[:user_id] = user.id 
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:logged_in?).and_return(true)
    controller.set_user_from_session
  end 

  describe 'POST #create' do
    context 'when user exists' do
      it 'logs the user in and returns a success message' do
        post :create, params: { email: user.email }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq('Logged in successfully')
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context 'when user does not exist' do
      it 'returns an error message' do
        post :create, params: { email: 'nonexistent@example.com' }, as: :json

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('User not found')
        expect(session[:user_id]).to be_nil
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is logged in' do
      before do
        session[:user_id] = user.id 
      end

      it 'logs the user out and returns a success message' do
        delete :destroy, params: { id: user.id }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Logged out successfully.')
        expect(session[:user_id]).to be_nil
      end
    end

    context 'when no user is logged in' do
      it 'still returns a success message but does not affect session' do
        delete :destroy, params: { id: user.id }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Logged out successfully.')
        expect(request.session[:user_id]).to be_nil
      end
    end
  end
end
