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

  
      binding.pry

      # assert representative.count eq(1) or assert representative = nancy pelosi
      # aseert representativesUser exist w/ the correct rep id

     

      
      # binding.pry

      rep_id = "P000197"

      # mock_representative = (
      #   id: rep_id,
      #   name: "Nancy Pelosi",
      #   state: "CA",
      #   phone: "123-456-7890",
      #   photo_url: "http://example.com/photo.jpg",
      #   party: "Democrat",
      #   district: "12",
      #   area: "California",
      #   reason: "Some Reason"
      # )
   

      allow(FetchRepresentativesService).to receive(:call).with("94110").and_return([mock_representative])
      allow(RepresentativePoro).to receive(:find_by_id).with(rep_id, [mock_representative]).and_return(mock_representative)
            
      expect(FetchRepresentativesService).to receive(:call).with("94110").and_return([mock_representative])

      

      puts "Response status: #{response.status}"
      puts "Response body: #{response.body}"

      json_response = JSON.parse(response.body)

      expect(response).to be_successful
      # binding.pry
      expect(response.status).to eq(201)

      # representative = Representative.find_by(name: "Jimmy Johnson", state: "MN")
      # expect(representative).not_to be_nil

      # rep_user_exists = RepresentativesUser.exists?(user_id: user.id, representative_id: representative.id)
      # expect(rep_user).to be true

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

 
