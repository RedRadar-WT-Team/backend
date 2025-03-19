# bundle exec rspec spec/poros/executive_order_spec.rb
require "rails_helper"
 
RSpec.describe ExecutiveOrderPoro do
  it "should create an Executive Order from JSON data" do
    
    sample_json = {
          "id": "2025-04444", 
          "title": "Zoo Dress Code",
          "document_number": "2025-04444",
          "html_url": "https://www.federalregister.gov/documents/2025/02/20/2025-02931/keeping-education-accessible-and-ending-covid-19-vaccine-mandates-in-schools",
          "pdf_url": "https://www.govinfo.gov/content/pkg/FR-2025-02-20/pdf/2025-02931.pdf",
          "publication_date": "2025-02-20"
    }

    zoo_executive_order = ExecutiveOrderPoro.new(sample_json)

    expect(zoo_executive_order).to be_an_instance_of ExecutiveOrderPoro
    expect(zoo_executive_order.id).to eq("2025-04444")
    expect(zoo_executive_order.title).to eq("Zoo Dress Code")
    expect(zoo_executive_order.document_number).to eq("2025-04444")
    expect(zoo_executive_order.html_url).to eq("https://www.federalregister.gov/documents/2025/02/20/2025-02931/keeping-education-accessible-and-ending-covid-19-vaccine-mandates-in-schools")
    expect(zoo_executive_order.pdf_url).to eq("https://www.govinfo.gov/content/pkg/FR-2025-02-20/pdf/2025-02931.pdf")
    expect(zoo_executive_order.publication_date).to eq("February 20, 2025")
  end
end