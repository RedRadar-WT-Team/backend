require "rails_helper"

RSpec.describe ExecutiveOrderGateway do
  it "retrieves the 5 most recent Executive Orders" do
    VCR.use_cassette("five_most_recent_executive_order_query") do

      executive_orders = ExecutiveOrderGateway.five_most_recent

      expect(executive_orders).not_to be_empty
      expect(executive_orders[0]).to be_an_instance_of(ExecutiveOrder)
      expect(executive_orders[0].id).to be_a(String)
      expect(executive_orders[0].title).to be_a(String)
      expect(executive_orders[0].document_number).to be_a(String)
      expect(executive_orders[0].html_url).to be_a(String)
      expect(executive_orders[0].pdf_url).to be_a(String)
      expect(executive_orders[0].publication_date).to be_a(String)
      expect(executive_orders.length).to eq(5)
    end
  end

  it "retrieves the ALL the Executive Orders for the current administration" do
    VCR.use_cassette("current_administration_executive_orders_query") do
      executive_orders = ExecutiveOrderGateway.current_administration_eos
      expect(executive_orders).not_to be_empty
      expect(executive_orders[0]).to be_an_instance_of(ExecutiveOrder)
      expect(executive_orders[0].id).to be_a(String)
      expect(executive_orders[0].title).to be_a(String)
      expect(executive_orders[0].document_number).to be_a(String)
      expect(executive_orders[0].html_url).to be_a(String)
      expect(executive_orders[0].pdf_url).to be_a(String)
      expect(executive_orders[0].publication_date).to be_a(String)
      expect(executive_orders.count).to be > 5
    end
  end
end