require "rails_helper"

RSpec.describe "representative endpoints", type: :request do 
  describe "api queried reps" do
    it "can render list of reps from api" do
      search_query = "94110"
      json_response = File.read('spec/fixtures/5calls_representatives_search_response.json')

      stub_request(:get, "https://api.5calls.org/v1/representatives?location=#{search_query}").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v2.12.2',
          'X-5calls-Token'=>"#{Rails.application.credentials.fiveCalls[:key]}"
           }).
         to_return(status: 200, body: json_response)

      get "/api/v1/representatives?db=false&query=#{search_query}"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      representatives = json[:data]
      expect(representatives.count).to eq(3)

      expect(representatives.first[:id]).to eq("P000197")
    end
  end

  describe "retrieve and render reps from db" do
    
  end
end