# bundle exec rspec spec/requests/api/v1/edit_user_spec.rb

require 'rails_helper'

RSpec.describe 'edit user request', type: :request do 
  let(:user) { create(:user) }
  let(:valid_update) {{ email: 'newemail@example.com', state: 'NY', zip: '10001' }}

  let(:empty_email) { { email: '' } }
  let(:incorrect_email) { { email: 'bademail' } }
  let(:short_zip) { { zip: '12' } }
  let(:empty_zip) { { zip: '' } }
  let(:empty_state) { { state: '' } }

  before do
    allow_any_instance_of(ApplicationController).to receive(:session).and_return({ user_id: user.id })
  end 

  it 'updates the user profile successfully' do
    patch api_v1_user_path(user), params: valid_update, as: :json

    expect(response).to have_http_status(:ok)

    json_response = JSON.parse(response.body, symbolize_names: true)

    expect(json_response[:message]).to eq("Account updated successfully!")
    expect(json_response[:data][:email]).to eq('newemail@example.com')
    expect(json_response[:data][:state]).to eq('NY')
    expect(json_response[:data][:zip]).to eq('10001')
  end

  describe 'sad paths' do 
    let(:invalid_headers) { { 'Content-Type' => 'application/json', 'X-User-Id' => '9999' } } # Invalid user ID for sad paths
    let(:user) { create(:user) }

    # Test missing required fields
    it 'returns an error when fields are missing' do
      patch api_v1_user_path(user), params: empty_email, as: :json
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:unprocessable_entity)

      expect(json_response[:error]).to eq("Email can't be blank")

      patch api_v1_user_path(user), params: empty_state, as: :json
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:error]).to eq("State can't be blank")

      patch api_v1_user_path(user), params: empty_zip, as: :json
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:error]).to eq("Zip can't be blank")
    end

    # Test invalid data inputs (email format, zip code)
    it 'returns an error when fields have invalid data' do
      patch api_v1_user_path(user), params: incorrect_email, as: :json
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:error]).to eq("Email is not a valid email format")

      patch api_v1_user_path(user), params: { zip: '12' }, as: :json
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:error]).to eq("Zip must be a valid 5-digit zip code")
    end

    # Test duplicate email error
    it 'returns an error when email is already taken' do
      user2 = create(:user)

      patch api_v1_user_path(user), params: { email: user2.email }, as: :json

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:error]).to eq("Email has already been taken")
    end

    # Test when user is not found
    it 'returns a 404 error when user is not found' do
      patch api_v1_user_path(user), params: { email: 'randomuser@example.com' }, as: :json
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:not_found)
      expect(json_response[:error]).to eq("User not found")
    end
  end
end