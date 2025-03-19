require "rails_helper"
RSpec.describe "Representative Users Endpoints" , type: :request do
  describe "Happy Paths" do
    before(:each) do
      @user = User.create!(email: "funtimes@wtf.com", state: "Canada", zip: "94110")
      # Set up test session for @user
      post "/api/v1/session", params: { email: "funtimes@wtf.com" }
    end

    it "can save a representative to the joins table of users and executive orders" do
      VCR.use_cassette('fetch_representatives_service_94110') do
          post "/api/v1/representatives_users", params: { id: "P000197", query: "94110", user_id: @user.id }
      end 

      expect(response).to be_successful
      expect(response.status).to eq(201)

      results = JSON.parse(response.body, symbolize_names: true)[:representative]
      binding.pry

      expect(Representative.count).to eq(1) 
      representative = Representative.first
      expect(results[:name]).to eq("Nancy Pelosi")
      expect(results[:phone]).to eq("202-225-4965")
      expect(results[:photo_url]).to eq("https://images.5calls.org/house/256/P000197.jpg")
      expect(results[:party]).to eq("Democrat")
      expect(results[:state]).to eq("CA")
      expect(results[:district]).to eq("11")

      expect(RepresentativesUser.count).to eq(1)
      representatives_user = RepresentativesUser.first
      expect(representatives_user.user_id).to eq(@user.id)
      expect(representatives_user.representative_id).to eq(representative.id)
    end

    it "can delete a record from the joins table of users and executive orders" do

      VCR.use_cassette('fetch_representatives_service_94110') do
        post "/api/v1/representatives_users", params: { id: "P000197", query: "94110", user_id: @user.id }
      end 
  
      results = JSON.parse(response.body, symbolize_names: true)[:representative]
    
      delete "/api/v1/representatives_users", params: { id: results[:id] }


      # delete api_v1_representatives_user_path(id: representatives_user.id)
      # delete "/api/v1/representatives_users/#{representatives_user.id}"

      expect(response).to be_successful
      # expect(response.status).to eq(204)
      # expect(RepresentativesUser.exists?(representatives_user.id)).to be false
    end
  end
end

 
 
