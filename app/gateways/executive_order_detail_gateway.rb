class ExecutiveOrderDetailGateway
  
  def self.find_specific_eo(document_number)
    Rails.cache.fetch("find_specific_eo_#{document_number}", expires_in: 12.hours) do
      selected_executive_order = hit_endpoint("api/v1/documents/#{document_number}.json")
      eo_poro = ExecutiveOrderPoro.new(selected_executive_order)
      
      # Generate summary if EO exists in DB but doesn't have a summary
      if (eo = ExecutiveOrder.find_by(executive_order_number: document_number))
        if !eo.summary.present? && eo_poro.pdf_url.present?
          text = PdfExtractionService.extract_text(eo_poro.pdf_url)
          eo.generate_and_save_summary(text) if text.present?
        end
      end
      
      eo_poro
    end
  end

  private

  def self.hit_endpoint(endpoint)
    response = connect.get(endpoint)
    parse_data(response)
  end
  
  def self.parse_data(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.connect
    Faraday.new(url: "https://www.federalregister.gov") 
  end
end