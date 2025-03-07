require 'rails_helper'

RSpec.describe 'GET /api/v1/profile', type: :request do
  let(:header) { { 'Content-Type' => 'application/json', 'X-User-Id' => user.id.to_s } }

  it 'returns the current user profile' do 
    get user_profile_path, headers: header
    json = JSON.parse(response.body, symbolize_names: true)


    expect(repsonse).to have_http_status(200)
    binding.pry
  end
end