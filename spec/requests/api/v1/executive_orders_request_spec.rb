require "rails_helper"
RSpec.describe "Executive Orders Endpoints" , type: :request do
  it "can retrieve a list of executive orders" do
    get "/api/v1/executive_orders"
    expect(response).to be_successful
    expect(response).to eq(200)
  end
end