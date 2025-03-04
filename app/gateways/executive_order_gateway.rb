class ExecutiveOrderGateway
  
  def self.five_most_recent
    Rails.cache.fetch("five_most_recent", expires_in: 12.hours) do
      executive_orders = set_query_params("api/v1/documents.json",{
        per_page: 5, 
        order: "newest",
        conditions: { 
          presidential_document_type: ["executive_order"], 
          president: ["donald-trump"] 
        }
      })
      executive_orders.map { |executive_order| ExecutiveOrder.new(executive_order)}
    end
  end

  # def self.current_administration_eo
  #   Rails.cache.fetch("five_most_recent", expires_in: 12.hours) do
  #     executive_orders = set_query_params("api/v1/documents.json",{
  #       order: "newest",
  #       conditions: { 
  #         presidential_document_type: ["executive_order"], 
  #         president: ["donald-trump"],
  #         publication_date: { 
  #           gte: "2025-01-20"
  #         }
  #       }
  #     })
  
  #     executive_order_objects = executive_orders.map { |executive_order| ExecutiveOrder.new(executive_order)}
  #   end
  # end

  private

  def self.set_query_params(endpoint, parameters = {})
    response = connect.get(endpoint) do |request|
      request.params = parameters
    end

    binding.pry

    parse_data(response)
  end
  
  def self.parse_data(response)
    JSON.parse(response.body, symbolize_names: true)[:results]
  end

  def self.connect
    Faraday.new(url: "https://www.federalregister.gov") 
  end
end