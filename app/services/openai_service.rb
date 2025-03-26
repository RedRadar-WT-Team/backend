class OpenaiService
  def self.generate_summary(text)
    return nil if text.blank?

    prompt = eo_summary_prompt(text)
    response = hit_endpoint("v1/chat/completions", {
      model: "gpt-3.5-turbo",
      messages: [
        { role: "system", content: "You are a helpful assistant that summarizes executive orders." },
        { role: "user", content: prompt }
      ],
      temperature: 0.7,
      max_tokens: 300
    })

    if response[:status] == 200
      response.dig(:choices, 0, :message, :content)
    end
  rescue => e
    Rails.logger.error("OpenAI API error: #{e.message}")
    nil
  end  

  private

  def self.eo_summary_prompt(text)
    "Please provide a TL;DR of this executive order: #{text}. Give a one to three-line high-level overview. Then please summarize the main points in plain, jargon-free language. Include who is affected, what the order is saying or implying, and note any potential areas of bias or spin. Keep it brief and easy to understand."
  end

  def self.hit_endpoint(endpoint, payload)
    response = connect.post(endpoint) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{Rails.application.credentials.dig(:open_ai, :key)}"
      req.body = payload.to_json
    end
    parse_data(response)
  end
  
  def self.parse_data(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.connect
    Faraday.new(url: "https://api.openai.com") do |f|
      f.request :json
      f.response :json
      f.adapter Faraday.default_adapter
    end
  end
end