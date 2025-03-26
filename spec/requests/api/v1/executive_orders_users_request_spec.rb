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
        publication_date: "March 5, 2025",
        pdf_url: "https://www.google.com/imgres?q=greenland%20open%20source&imgurl=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2Ff%2Ff9%2FGreenland-ice_sheet_hg.jpg&imgrefurl=https%3A%2F%2Fcommons.wikimedia.org%2Fwiki%2FFile%3AGreenland-ice_sheet_hg.jpg&docid=e11FvoTbFIavvM&tbnid=yQl3fsOLIl9eoM&vet=12ahUKEwjF_PSw4aaMAxX3MkQIHWuZHRcQM3oECGgQAA..i&w=5209&h=3547&hcb=2&ved=2ahUKEwjF_PSw4aaMAxX3MkQIHWuZHRcQM3oECGgQAA"
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
      results = JSON.parse(response.body, symbolize_names: true)

      
      expect(response).to be_successful
      expect(response.status).to eq(200)
    end
  end
end