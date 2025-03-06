# bundle exec rspec spec/requests/api/v1/edit_user_spec.rb

require 'rails_helper'

RSpec.describe 'PATCH /api/v1/users', type: :request do 
  let(:user) { create(:user) }

  let(:valid_input) {{ email: 'newemail@example.com', state: 'NY', zip: '10001' }}

  let(:duplicate_email) { { email: 'newemail@example.com' } }
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

    valid_params = valid_input.to_json
    
    patch "/api/v1/users/#{user.id}", params: valid_params, headers: headers

    expect(response).to have_http_status(:ok)

    json_response = JSON.parse(response.body, symbolize_names: true)

    expect(json_response[:message]).to eq("Account updated successfully!")
    expect(json_response[:data][:email]).to eq('newemail@example.com')
    expect(json_response[:data][:state]).to eq('NY')
    expect(json_response[:data][:zip]).to eq('10001')
  end

  it 'returns an error when fields are missing' do

  end

  it 'returns an error when input is invalid' do
    
  end
end