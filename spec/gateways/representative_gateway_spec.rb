require "rails_helper"

RSpec.describe RepresentativeGateway do
  it "should make a call to the 5calls api retrieve representatives based on their zip code" do
    # INPUT -> zip code from search query
    # Output -> JSON response -> list of representatives
    search_query = "94110"
    json_response = File.read('spec/fixtures/5calls_representatives_search_response.json')

    stub_request(:get, "https://api.5calls.org/v1/representatives?location=#{search_query}").
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>"Bearer #{Rails.application.credentials.fiveCalls[:key]}",
          'User-Agent'=>'Faraday v2.10.1'
        }).
        to_return(status: 200, body: json_response)

    fetched_response = RepresentativeGateway.fetch_queried_reps()
    fetched_representatives = fetched_response[:representatives]

    expect(fetched_representatives.count).to eq(3)

    fetched_representatives.each do |reps|
      expect(rep).to have_key :id
      expect(rep).to have_key :name
      expect(rep).to have_key :phone
      expect(rep).to have_key :photoURL
      expect(rep).to have_key :party
      expect(rep).to have_key :state
      expect(rep).to have_key :district
      expect(rep).to have_key :area
      expect(rep).to have_key :reason
    end
  end
end