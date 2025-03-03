require "rails_helper"
# require '/app/gateways/executive_order_gateway'



RSpec.describe ExecutiveOrderGateway do
  it "should make a call to Federalist to retrieve 5 most recent Executive Orders" do
    require 'pry'; binding.pry
    executive_orders = ExecutiveOrderGateway.five_most_recent

    expect(executive_orders[0]).not_to be_nil
    expect(executive_orders[0]).to be_an_instance_of(ExecutiveOrder)
  end
end