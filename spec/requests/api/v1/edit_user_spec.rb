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

  it 'updates the user profile successfully' do
    patch "/api/v1/users/#{user.id}", params: valid_input, headers: { 'Content-Type' => 'application/json' }

    expect(response).to have_http_status(:ok)

    json_response = JSON.parse(response.body, symbolize_names: true)

    expect(json_response[:data][:attributes][:email]).to eq('newemail@example.com')
    expect(json_response[:data][:attributes][:state]).to eq('NY')
    expect(json_response[:data][:attributes][:zip]).to eq('10001')
  end

  it 'returns an error when fields are missing' do

  end

  it 'returns an error when input is invalid' do
    
  end
end