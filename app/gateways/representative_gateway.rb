class RepresentativeGateway
  def self.fetch_queried_reps(query)
    conn = connect()
    response = conn.get("/v1/representatives", {location: query})

    json = JSON.parse(response.body, symbolize_names: true)

    json[:representatives]
  end

  private

  def self.connect
    conn = Faraday.new(url: "https://api.5calls.org") do |faraday|
      faraday.headers["X-5Calls-Token"] = Rails.application.credentials.fiveCalls[:key]
    end

    return conn
  end
end