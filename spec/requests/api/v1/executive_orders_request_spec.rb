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

  describe "Edge Cases and Error Handling" do
    it "returns empty data when there are no executive orders" do
      allow(ExecutiveOrderGateway).to receive(:current_administration_eos).and_return([])
      
      get "/api/v1/executive_orders"
      
      expect(response).to be_successful
      expect(response.status).to eq(200)
      
      results = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(results).to eq([])
    end

    it "returns a 404 when a non-existent executive order is requested" do
      allow(ExecutiveOrderDetailGateway).to receive(:find_specific_eo).with("34203482305820582309528").and_return(nil)
      
      get "/api/v1/executive_orders/34203482305820582309528"
      
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      
      error = JSON.parse(response.body, symbolize_names: true)
      expect(error[:error]).to eq("Executive order not found")
    end

    it "handles errors in the index action" do
      allow(ExecutiveOrderGateway).to receive(:current_administration_eos).and_raise(StandardError.new("API Error"))
      
      get "/api/v1/executive_orders"
      
      expect(response).to_not be_successful
      expect(response.status).to eq(500)
      
      error = JSON.parse(response.body, symbolize_names: true)
      expect(error[:error]).to eq("API Error")
    end

    it "handles errors in the recent action" do
      allow(ExecutiveOrderGateway).to receive(:five_most_recent).and_raise(StandardError.new("Recent API Error"))
      
      get "/api/v1/executive_orders/recent"
      
      expect(response).to_not be_successful
      expect(response.status).to eq(500)
      
      error = JSON.parse(response.body, symbolize_names: true)
      expect(error[:error]).to eq("Recent API Error")
    end

    it "handles gateway errors gracefully" do
      allow(ExecutiveOrderGateway).to receive(:current_administration_eos).and_raise(StandardError.new("API Error"))
      
      get "/api/v1/executive_orders"
      
      expect(response).to_not be_successful
      expect(response.status).to eq(500)
      
      error = JSON.parse(response.body, symbolize_names: true)
      expect(error[:error]).to eq("API Error")
    end

    it "handles exceptions during the create action" do
      allow(ExecutiveOrder).to receive(:new).and_raise(StandardError.new("Creation failed"))
      
      post "/api/v1/executive_orders", params: { title: "Test Order" }
      
      expect(response).to_not be_successful
      expect(response.status).to eq(500)
      
      error = JSON.parse(response.body, symbolize_names: true)
      expect(error[:error]).to eq("Creation failed")
    end

    it "handles validation errors when creating invalid executive orders" do
      mock_eo = instance_double("ExecutiveOrder")
      allow(ExecutiveOrder).to receive(:new).and_return(mock_eo)
      allow(mock_eo).to receive(:save).and_return(false)
      allow(mock_eo).to receive(:errors).and_return(
        double(full_messages: ["Publication date can't be blank"])
      )
      
      post "/api/v1/executive_orders", params: { title: "Test Order" }
      
      expect(response).to_not be_successful
      expect(response.status).to eq(422)
      
      error = JSON.parse(response.body, symbolize_names: true)
      expect(error[:errors]).to include("Publication date can't be blank")
    end
  end
end