# bundle exec rspec spec/requests/api/v1/edit_user_spec.rb

require 'rails_helper'

RSpec.describe 'PATCH /api/v1/users', type: :request do 
  let(:user) { create(:user) }

  let(:valid_update) {{ email: 'newemail@example.com', state: 'NY', zip: '10001' }}

  let(:empty_email) { { email: '' } }
  let(:incorrect_email) { { email: 'bademail' } }

  let(:short_zip) { { zip: '12' } }
  let(:empty_zip) { { zip: '' } }

  let(:empty_state) { { state: '' } }

  before do
    # this mocks controller behavior to avoid having an actual login flow
    allow(controller).to receive(:current_user).and_return(user)
  end 

  it 'updates the user profile successfully' do
    # simulate user session for the request
    headers = { 'Content-Type' => 'application/json', 'X-User-Id' => user.id.to_s }

    valid_params = valid_update.to_json
    
    patch "/api/v1/users/#{user.id}", params: valid_params, headers: headers

    expect(response).to have_http_status(:ok)

    json_response = JSON.parse(response.body, symbolize_names: true)

    expect(json_response[:message]).to eq("Account updated successfully!")
    expect(json_response[:data][:email]).to eq('newemail@example.com')
    expect(json_response[:data][:state]).to eq('NY')
    expect(json_response[:data][:zip]).to eq('10001')
  end

  describe 'sad paths' do 
    before :each do 
      @user1 = create(:user)
      @user2 = create(:user)
      @headers = { 'Content-Type' => 'application/json', 'X-User-Id' => @user2.id.to_s }

      allow(controller).to receive(:current_user).and_return(@user2)
    end
    
    it 'returns an error when fields are missing' do
      invalid_email= empty_email.to_json
      patch "/api/v1/users/#{@user2.id}", params: invalid_email, headers: @headers
      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:errors]).to eq("Email can't be blank")

      invalid_state= empty_state.to_json
      patch "/api/v1/users/#{@user2.id}", params: invalid_state, headers: @headers
      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:errors]).to eq("State can't be blank")

      invalid_zip= empty_zip.to_json
      patch "/api/v1/users/#{@user2.id}", params: invalid_zip, headers: @headers
      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:errors]).to eq("Zip can't be blank")
    end

    it 'returns a different error when input is invalid' do
      duplicate_email = { user: { email: @user1.email } }.to_json
      patch "/api/v1/users/#{user.id}", params: duplicate_email, headers: @headers
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:errors]).to eq("Email has already been taken")

    incorrect_zip = short_zip.to_json
      patch "/api/v1/users/#{user.id}", params: incorrect_zip, headers: @headers
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:errors]).to eq("Zip must be a valid 5-digit zip code")
    end
  end
end