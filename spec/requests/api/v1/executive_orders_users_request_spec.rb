require "rails_helper"
RSpec.describe "Executive Orders Users Endpoints" , type: :request do
  describe "Happy Paths" do
    it "can save an executive order to the joins table of users and executive orders" do
      document_number = "2025-03527"
      get "/api/v1/executive_orders_users/#{document_number}" 
    end
  end
end