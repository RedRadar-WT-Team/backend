require "rails_helper"

RSpec.describe ExecutiveOrderDetailGateway do
  VCR.use_cassette("single_eo_executive_order_query") do
    document_number = 2025-03527
    selected_executive_order = ExecutiveOrderDetailGateway.find_specific_eo(document_number)

    expect(selected_executive_order).not_to be_empty
    expect(selected_executive_order[0]).to be_an_instance_of(ExecutiveOrder)
    expect(selected_executive_order[0].id).to be_a(String)
    expect(selected_executive_order[0].title).to be_a(String)
    expect(selected_executive_order[0].document_number).to be_a(String)
    expect(selected_executive_order[0].html_url).to be_a(String)
    expect(selected_executive_order[0].pdf_url).to be_a(String)
    expect(selected_executive_order[0].publication_date).to be_a(String)
    expect(selected_executive_order.length).to eq(1)
  end
end