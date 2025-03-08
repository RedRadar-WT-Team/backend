require 'rails_helper'

RSpec.describe 'GET /api/v1/profile', type: :request do
  it 'returns the current user profile' do 
    user = create(:user)
    get "/api/v1/users/show?email=#{user.email}"
  
    expect(response).to have_http_status(200)

    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data][:attributes][:id]).to eq(user.id)
    expect(json[:data][:attributes][:email]).to eq(user.email)
    expect(json[:data][:attributes][:state]).to eq(user.state)
    expect(json[:data][:attributes][:zip]).to eq(user.zip)
  end
end