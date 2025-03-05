require "rails_helper"
RSpec.describe "Executive Orders Endpoints" , type: :request do
  describe "Happy Paths" do
    it "can retrieve a list of executive orders from current adminstration" do
      VCR.use_cassette("list_of_all_executive_orders_query") do
        get "/api/v1/executive_orders"
        
        expect(response).to be_successful
        expect(response.status).to eq(200)
        
        results = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(results.length).to be > 70
        expect(results[0][:attributes][:id]).to be_a(String)
        expect(results[0][:attributes][:title]).to be_a(String)
        expect(results[0][:attributes][:document_number]).to be_a(String)
        expect(results[0][:attributes][:html_url]).to be_a(String)
        expect(results[0][:attributes][:pdf_url]).to be_a(String)
        expect(results[0][:attributes][:publication_date]).to be_a(String)
      end
    end

    it "can retrieve a list of the five most recent executive orders" do
      VCR.use_cassette("list_of_five_most_recent_executive_orders_query") do
        get "/api/v1/executive_orders/recent"
        
        expect(response).to be_successful
        expect(response.status).to eq(200)
        
        results = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(results.length).to eq(5)
        expect(results[1][:attributes][:id]).to be_a(String)
        expect(results[1][:attributes][:title]).to be_a(String)
        expect(results[1][:attributes][:document_number]).to be_a(String)
        expect(results[1][:attributes][:html_url]).to be_a(String)
        expect(results[1][:attributes][:pdf_url]).to be_a(String)
        expect(results[1][:attributes][:publication_date]).to be_a(String)
      end
    end

    it "can retrieve a specific executive order" do
      VCR.use_cassette("specific_executive_order_query") do
        document_number = "2025-03527"
        get "/api/v1/executive_orders/#{document_number}" 
        
        expect(response).to be_successful
        expect(response.status).to eq(200)
        
        result = JSON.parse(response.body, symbolize_names: true)[:data]
        
        expect(result[:attributes][:id]).to eq("2025-03527")
        expect(result[:attributes][:title]).to eq("Implementing the President's \"Department of Government Efficiency\" Cost Efficiency Initiative")
        expect(result[:attributes][:document_number]).to eq("2025-03527")
        expect(result[:attributes][:html_url]).to eq("https://www.federalregister.gov/documents/2025/03/03/2025-03527/implementing-the-presidents-department-of-government-efficiency-cost-efficiency-initiative")
        expect(result[:attributes][:pdf_url]).to eq("https://www.govinfo.gov/content/pkg/FR-2025-03-03/pdf/2025-03527.pdf")
        expect(result[:attributes][:publication_date]).to eq("March 03, 2025")
      end
    end
  end
end