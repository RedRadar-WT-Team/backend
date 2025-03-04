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

      get "/api/v1/representatives/search?db=false&query=#{search_query}"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      representatives = json[:data]
      expect(representatives.count).to eq(3)
    
      expect(representatives.first[:id]).to eq("P000197")
      expect(representatives.first[:attributes][:name]).to eq("Nancy Pelosi")
      expect(representatives.first[:attributes][:party]).to eq("Democrat")
      expect(representatives.first[:attributes][:phone]).to eq("202-225-4965")
      expect(representatives.first[:attributes][:photo_url]).to eq("https://images.5calls.org/house/256/P000197.jpg")
      expect(representatives.first[:attributes][:state]).to eq("CA")
      expect(representatives.first[:attributes][:district]).to eq("11")
      expect(representatives.first[:attributes][:area]).to eq("US House")
      expect(representatives.first[:attributes][:reason]).to eq("This is your representative in the House.")
    end

    it "can retrieve one representative out of a list of reps from the api by id" do
      search_query = "94110"
      target_id = "P000197"
      json_response = File.read("spec/fixtures/5calls_representatives_search_response.json")

      stub_request(:get, "https://api.5calls.org/v1/representatives?location").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v2.12.2',
          'X-5calls-Token'=>"#{Rails.application.credentials.fiveCalls[:key]}"
           }).
         to_return(status: 200, body: json_response)

      get "/api/v1/representatives/details?db=false&location=#{search_query}&id=#{target_id}"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      representative = json[:data]

      expect(representative[:id]).to eq("P000197")
      expect(representative[:attributes][:name]).to eq("Nancy Pelosi")
      expect(representative[:attributes][:party]).to eq("Democrat")
      expect(representative[:attributes][:phone]).to eq("202-225-4965")
      expect(representative[:attributes][:photo_url]).to eq("https://images.5calls.org/house/256/P000197.jpg")
      expect(representative[:attributes][:state]).to eq("CA")
      expect(representative[:attributes][:district]).to eq("11")
      expect(representative[:attributes][:area]).to eq("US House")
      expect(representative[:attributes][:reason]).to eq("This is your representative in the House.")
    end
  end

  describe "retrieve and render reps from db" do
    
  end
end