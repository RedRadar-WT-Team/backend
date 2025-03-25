require "rails_helper"

RSpec.describe ExecutiveOrderDetailGateway do
  describe ".find_specific_eo" do
    let(:document_number) { "2025-03527" }
    
    it "retrieves a specific Executive Order", :vcr do
      VCR.use_cassette("single_eo_executive_order_query") do
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

    context "when EO exists in database" do
      let!(:executive_order) { create(:executive_order, executive_order_number: document_number) }

      context "when EO has no summary" do
        before do
          allow(PdfExtractionService).to receive(:extract_text).and_return("Sample PDF text")
          allow(OpenaiService).to receive(:generate_summary).and_return("Generated summary")
        end

        it "generates and saves a summary", :vcr do
          VCR.use_cassette("single_eo_executive_order_query") do
            expect {
              ExecutiveOrderDetailGateway.find_specific_eo(document_number)
            }.to change { executive_order.reload.summary }.from(nil).to("Generated summary")
          end
        end
      end

      context "when EO already has a summary" do
        let!(:executive_order) { create(:executive_order, executive_order_number: document_number, summary: "Existing summary") }

        it "does not regenerate the summary", :vcr do
          VCR.use_cassette("single_eo_executive_order_query") do
            expect(PdfExtractionService).not_to receive(:extract_text)
            expect(OpenaiService).not_to receive(:generate_summary)
            
            ExecutiveOrderDetailGateway.find_specific_eo(document_number)
            expect(executive_order.reload.summary).to eq("Existing summary")
          end
        end
      end

      context "when PDF extraction fails" do
        before do
          allow(PdfExtractionService).to receive(:extract_text).and_return(nil)
        end

        it "does not generate a summary", :vcr do
          VCR.use_cassette("single_eo_executive_order_query") do
            expect(OpenaiService).not_to receive(:generate_summary)
            
            ExecutiveOrderDetailGateway.find_specific_eo(document_number)
            expect(executive_order.reload.summary).to be_nil
          end
        end
      end

      context "when OpenAI generation fails" do
        before do
          allow(PdfExtractionService).to receive(:extract_text).and_return("Sample PDF text")
          allow(OpenaiService).to receive(:generate_summary).and_return(nil)
        end

        it "does not save a summary", :vcr do
          VCR.use_cassette("single_eo_executive_order_query") do
            ExecutiveOrderDetailGateway.find_specific_eo(document_number)
            expect(executive_order.reload.summary).to be_nil
          end
        end
      end
    end
  end
end