require "rails_helper"
RSpec.describe "Representative Users Endpoints" , type: :request do
  describe "Happy Paths" do
    it "can save a representative to the joins table of users and executive orders" do
      user = User.create!(email: "funtimes@wtf.com", state: "Canada", zip: "94110")

      RepresentativesUser.destroy_all
      Representative.destroy_all

      VCR.use_cassette('fetch_representatives_service_94110') do
          post "/api/v1/representatives_users", params: { id: "P000197", query: "94110", user_id: user.id }
      end 
       
      expect(response).to be_successful
      expect(response.status).to eq(201)

      results = JSON.parse(response.body, symbolize_names: true)[:representative]

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
      expect(representatives_user.user_id).to eq(user.id)
      expect(representatives_user.representative_id).to eq(representative.id)

      

     



      # assert representative.count eq(1) or assert representative = nancy pelosi
      # aseert representativesUser exist w/ the correct rep id
   

      # allow(FetchRepresentativesService).to receive(:call).with("94110").and_return([mock_representative])
      # allow(RepresentativePoro).to receive(:find_by_id).with(rep_id, [mock_representative]).and_return(mock_representative)
            
      # expect(FetchRepresentativesService).to receive(:call).with("94110").and_return([mock_representative])
   
    end
  end
end

    # it "can unsave a representative to the joins table users and executive orders" do
    #   user = User.create!(email: "funtimes@wtf.com", state: "Canada", zip: "11111")

    #   respresentative = Representative.create!(name: "jimmy", phone: "873-456-8954", photo_url: "https://theplanetd.com/beautiful-places-in-the-world/", party: "democrat", state: "MN", district: "US House", area: "55448", reason: "cheese")

    #   RepresentativesUser.create!(user_id: user.id, representative_id: representative.id)
    #   # binding.pry
    #   delete "/api/v1/representativess_users/destroy" 

    #   expect(response).to be_successful
    #   expect(response.status).to eq(204)
    # end

 
