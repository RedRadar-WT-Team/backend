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
          'User-Agent'=>'Faraday v2.12.2',
          'X-5calls-Token'=>"#{Rails.application.credentials.fiveCalls[:key]}"
           }).
         to_return(status: 200, body: json_response)

    fetched_representatives = RepresentativeGateway.fetch_queried_reps("94110")
    
    expect(fetched_representatives.count).to eq(3)
    
    fetched_representatives.each do |rep|
      expect(rep).to respond_to(:id, 
                                :name, 
                                :phone, 
                                :photo_url, 
                                :party, 
                                :state, 
                                :district, 
                                :area, 
                                :reason,
                                :location)
    end
  end
end