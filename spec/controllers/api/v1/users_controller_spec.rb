# bundle exec rspec spec/controllers/api/v1/users_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:valid_attributes) { { email: 'user@example.com', state: 'CA', zip: '90001' } }
  let(:invalid_attributes) { { email: '', state: 'CA', zip: '90001' } }
  let(:updated_attributes) { { email: 'newemail@example.com', state: 'NY', zip: '10001' } }

  describe 'POST #create' do
    context 'when valid parameters are provided' do
      it 'creates a new user' do
        post :create, params: { user: valid_attributes }
      
        created_user = User.last
      
        expect(response).to have_http_status(:created)
        expect(created_user.email).to eq(valid_attributes[:email])
        expect(created_user.state).to eq(valid_attributes[:state])
        expect(created_user.zip).to eq(valid_attributes[:zip])

        message = JSON.parse(response.body)['message']
        expect(message).to eq('Account created successfully!')
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
    context 'when the user is logged in' do
      it 'assigns the current user and returns status ok' do
        new_user = create(:user)
        session[:current_user_email] = new_user.email

        get :show, params: { id: new_user.id }

        expect(response).to have_http_status(:ok)
        expect(controller.current_user).to eq(new_user)
      end
    end

    context 'when the user is not logged in' do
      it 'returns an error and unauthorized status' do
        unauthorized_user = create(:user)
        session[:current_user_email] = nil

        get :show, params: { id: unauthorized_user.id }

        json_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:unauthorized)
        expect(json_response[:error]).to eq("You must be logged in to access your profile.")
      end
    end
  end

  describe 'PATCH #update' do
    context 'when the user is logged in' do
      before do
        @new_user = create(:user)
        session[:current_user_email] = @new_user.email
      end

      it 'updates the user successfully with valid parameters' do
        patch :update, params: { id: @new_user.id, user: updated_attributes }

        @new_user.reload
        expect(response).to have_http_status(:ok)
        expect(@new_user.email).to eq(updated_attributes[:email])
        expect(@new_user.state).to eq(updated_attributes[:state])
        expect(@new_user.zip).to eq(updated_attributes[:zip])

        message = JSON.parse(response.body)['message']
        expect(message).to eq('Account updated successfully!')
      end

      it 'returns an error when invalid parameters are provided' do
        patch :update, params: { id: @new_user.id, user: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        error_message = JSON.parse(response.body)['errors']
        expect(error_message).to eq("Email can't be blank")
      end
    end

    context 'when the user is not logged in' do
      it 'returns an error with an unauthorized status' do
        user = create(:user)
        session[:current_user_email] = nil
        patch :update, params: { id: user.id, user: updated_attributes }

        json_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:unauthorized)
        expect(json_response[:error]).to eq("You must be logged in to update your profile.")
      end
    end

    context 'when updating another user profile' do
      before do
        @user1 = create(:user)
        @another_user = create(:user)
        session[:current_user_email] = @user1.email
      end

      it 'returns forbidden when trying to update another user profile' do
        patch :update, params: { id: @another_user.id, user: updated_attributes }

        json_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:forbidden)
        expect(json_response[:error]).to eq("You are not authorized to update this profile.")
      end
    end
  end
end