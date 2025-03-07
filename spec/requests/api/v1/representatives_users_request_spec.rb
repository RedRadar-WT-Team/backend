require "rails_helper"
RSpec.describe "Representative Users Endpoints" , type: :request do
  describe "Happy Paths" do
    it "can save a representative to the joins table of users and executive orders" do
      user = User.create!(email: "funtimes@wtf.com", state: "Canada", zip: "11111")

      rep_data = Representative.create!(
        name: "jimmy", 
        phone: "873-456-8954", 
        photo_url: "https://theplanetd.com/beautiful-places-in-the-world/", 
        party: "democrat", 
        state: "MN", 
        district: "US House", 
        area: "55448", 
        reason: "cheese"
      )

      post "/api/v1/representatives_users", params: { representative: rep_data }
      
      expect(response).to be_successful
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

 
