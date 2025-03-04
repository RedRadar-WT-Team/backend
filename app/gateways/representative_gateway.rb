class RepresentativeGateway
  def self.fetch_queried_reps(query)
    conn = connect()
    response = conn.get("/v1/representatives", {location: query})

    json = JSON.parse(response.body, symbolize_names: true)
    district = json[:district]
    
    rep_data = json[:representatives].map do |rep|
      filtered_rep = rep.slice(:id, :name, :phone, :photoURL, :party, :state, :area, :reason)
      RepresentativePoro.new(filtered_rep, district)
    end

    return rep_data
  end

  private

  def self.connect
    conn = Faraday.new(url: "https://api.5calls.org") do |faraday|
      faraday.headers["X-5Calls-Token"] = Rails.application.credentials.fiveCalls[:key]
    end

    return conn
  end
end