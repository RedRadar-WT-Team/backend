require "rails_helper"

RSpec.describe ExecutiveOrderGateway do
  it "should make a call to Federalist to retrieve 5 most recent Executive Orders",
    executive_orders = ExecutiveOrderGateway.five_most_recent

    expect(executive_orders[0]).not_to be_nil
    expect(executive_orders[0]).to be_an_instance_of(ExecutiveOrder)    

    # json_response.map do |movie|
      expect(movie.title).to be_an(String)
      expect(movie.vote_average).to be_an(Float)
    # end
  end
end