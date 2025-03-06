require "rails_helper"

RSpec.describe ExecutiveOrderDetailGateway do
  it "Retrieves a specific Executive Order", :vcr do
    VCR.use_cassette("single_eo_executive_order_query") do
      document_number = "2025-03527"
    
      selected_executive_order = ExecutiveOrderDetailGateway.find_specific_eo(document_number)
      
      expect(selected_executive_order).to be_an_instance_of(ExecutiveOrderPoro)
      expect(selected_executive_order.id).to be_a(String)
      expect(selected_executive_order.title).to be_a(String)
      expect(selected_executive_order.document_number).to be_a(String)
      expect(selected_executive_order.html_url).to be_a(String)
      expect(selected_executive_order.pdf_url).to be_a(String)
      expect(selected_executive_order.publication_date).to be_a(String)
    end
  end
end