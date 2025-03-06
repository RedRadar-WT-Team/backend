class ExecutiveOrderDetailGateway
  
  def self.find_specific_eo(document_number)
    Rails.cache.fetch("find_specific_eo_#{document_number}", expires_in: 12.hours) do
      selected_executive_order = hit_endpoint("api/v1/documents/#{document_number}.json")
  
      ExecutiveOrderPoro.new(selected_executive_order)
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