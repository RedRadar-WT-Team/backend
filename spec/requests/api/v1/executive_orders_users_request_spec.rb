require "rails_helper"
RSpec.describe "Executive Orders Users Endpoints" , type: :request do
  describe "Happy Paths" do
    before(:each) do
      @user = User.create!(email: "funtimes@wtf.com", state: "Canada", zip: "11111")
      # Set up test session for @user
      post "/api/v1/session", params: { email: "funtimes@wtf.com" }

      @executive_order = ExecutiveOrder.create!(
        title: "We own Greenland",
        html_url: "https://i.imgflip.com/384b70.jpg",
        executive_order_number: "2025-03289",
        publication_date: "March 5, 2025"
      )
    end

    it "can save an executive order to the joins table of users and executive orders" do
      post "/api/v1/executive_orders_users", params: { executive_order_number: @executive_order.executive_order_number}
      expect(response).to be_successful
      expect(response.status).to eq(201)
    end

    it "can unsave an executive order from the joins table of users and executive orders" do
      EOUser = ExecutiveOrdersUser.create!(user_id: @user.id, executive_order_id: @executive_order.id)

      delete "/api/v1/executive_orders_users/#{EOUser.id}" 

      expect(response).to be_successful
      expect(response.status).to eq(204)
    end
  end
end