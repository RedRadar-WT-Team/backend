class ExecutiveOrderDetailGateway
  
  def self.find_specific_eo(document_number)
    selected_executive_order = hit_endpoint("api/v1/documents/#{document_number}.json")
    
    # Find or create the executive order in our database
    eo = ExecutiveOrder.find_by(executive_order_number: document_number)
    if !eo
      eo = ExecutiveOrder.create!(
        executive_order_number: document_number,
        title: selected_executive_order[:title],
        html_url: selected_executive_order[:html_url],
        pdf_url: selected_executive_order[:pdf_url],
        publication_date: selected_executive_order[:publication_date]
      )
    end
    
    # Generate summary if needed
    if !eo.summary.present? && eo.pdf_url.present?
      text = PdfExtractionService.extract_text(eo.pdf_url)
      eo.generate_and_save_summary(text) if text.present?
    end
    
    eo
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