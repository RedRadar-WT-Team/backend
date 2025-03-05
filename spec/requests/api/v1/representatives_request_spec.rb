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
    before do
      @rep1 = Representative.create!(
        name: "Nancy Pelosi",
        phone: "202-225-4965",
        photo_url: "https://images.5calls.org/house/256/P000197.jpg",
        party: "Democrat",
        state: "CA",
        district: "11",
        area: "US House",
        reason: "This is your representative in the House."
      )
  
      @rep2 = Representative.create!(
        name: "Adam Schiff",
        phone: "202-224-3841",
        photo_url: "https://images.5calls.org/senate/256/S001150.jpg",
        party: "Democrat",
        state: "CA",
        district: "11",
        area: "US Senate",
        reason: "This is one of your two Senators."
      )
  
      @rep3 = Representative.create!(
        name: "Alex Padilla",
        phone: "202-224-3553",
        photo_url: "https://images.5calls.org/senate/256/P000145.jpg",
        party: "Democrat",
        state: "CA",
        district: "11",
        area: "US Senate",
        reason: "This is one of your two Senators."
      )
    end

    it "can render list of reps from db" do
      get "/api/v1/representatives?db=true"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data].count).to eq(3)

      first_rep = json[:data].first[:attributes]
      expect(first_rep[:name]).to eq("Nancy Pelosi")
      expect(first_rep[:phone]).to eq("202-225-4965")
      expect(first_rep[:party]).to eq("Democrat")
      expect(first_rep[:state]).to eq("CA")
      expect(first_rep[:district]).to eq("11")
      expect(first_rep[:area]).to eq("US House")
      expect(first_rep[:reason]).to eq("This is your representative in the House.")

      last_rep = json[:data].last[:attributes]
      expect(last_rep[:name]).to eq("Alex Padilla")
      expect(last_rep[:phone]).to eq("202-224-3553")
      expect(last_rep[:party]).to eq("Democrat")
      expect(last_rep[:state]).to eq("CA")
      expect(last_rep[:district]).to eq("11")
      expect(last_rep[:area]).to eq("US Senate")
      expect(last_rep[:reason]).to eq("This is one of your two Senators.")
    end

    it "renders empty array when no reps are found in db" do
      Representative.destroy_all
  
      get "/api/v1/representatives?db=true"
  
      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data]).to be_empty
    end

    it "can render rep searched by id in db" do
      get "/api/v1/representatives/#{@rep1.id}"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:attributes][:name]).to eq("Nancy Pelosi")
      expect(json[:data][:attributes][:phone]).to eq("202-225-4965")
      expect(json[:data][:attributes][:party]).to eq("Democrat")
      expect(json[:data][:attributes][:state]).to eq("CA")
      expect(json[:data][:attributes][:district]).to eq("11")
      expect(json[:data][:attributes][:area]).to eq("US House")
      expect(json[:data][:attributes][:reason]).to eq("This is your representative in the House.")

      get "/api/v1/representatives/#{@rep3.id}"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:attributes][:name]).to eq("Alex Padilla")
      expect(json[:data][:attributes][:phone]).to eq("202-224-3553")
      expect(json[:data][:attributes][:party]).to eq("Democrat")
      expect(json[:data][:attributes][:state]).to eq("CA")
      expect(json[:data][:attributes][:district]).to eq("11")
      expect(json[:data][:attributes][:area]).to eq("US Senate")
      expect(json[:data][:attributes][:reason]).to eq("This is one of your two Senators.")
    end

    it "returns a 404 error when rep id is not found" do
      get "/api/v1/representatives/999999"
    
      expect(response.status).to eq(404)
      json = JSON.parse(response.body, symbolize_names: true)
      
      expect(json[:error]).to eq("Representative not found")
    end

    it "can create a new representative to the db" do
      rep_params = {
        name: "Jamie Raskin",
        phone: "202-225-5341",
        photo_url: "https://images.5calls.org/house/256/R000606.jpg",
        party: "Democrat",
        state: "MD",
        district: "8",
        area: "US House",
        reason: "This is your representative in the House."
      }

      post "/api/v1/representatives", params: { representative: rep_params }

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:attributes][:name]).to eq("Jamie Raskin")
      expect(json[:data][:attributes][:phone]).to eq("202-225-5341")
      expect(json[:data][:attributes][:party]).to eq("Democrat")
      expect(json[:data][:attributes][:state]).to eq("MD")
      expect(json[:data][:attributes][:district]).to eq("8")
      expect(json[:data][:attributes][:area]).to eq("US House")
      expect(json[:data][:attributes][:reason]).to eq("This is your representative in the House.")
    end
  end
end


import './App.css'
import { Routes, Route } from 'react-router-dom';
import Header from '../Header/Header';
import { useState } from 'react';
// import SearchBar from '../SearchBar/SearchBar';
import Ticker from '../Ticker/Ticker';

function App() {
  const dummyExecutiveOrders = [
    {id: 1000, title: "Zoo Dress Code", summary: "Walruses must wear pants."}, 
    {id: 2000, title: "Ice Scream", summary: "Mandatory screaming upon consumption of Mint Chocolate Chip Ice Cream on Thursdays."}, 
    {id: 3000, title: "Middle Name Penalty", summary: "Those with a middle 'L' initial must walk backwards all day on the Sabbath."},
    {id: 4000, title: "Bye Bye Cap'n Crunch", summary: "If you like Cap'n Crunch, no more Cap'n Crunch for you."},
    {id: 5000, title: "Cuz 'Mercuh", summary: "Fireworks at 3:30 am. Everyday. Even Saturdays."}
  ]
  const [executiveOrders] = useState(dummyExecutiveOrders);
  const [repData, setRepData] = useState([]);

  function getRepData(query) {
    fetch(`/api/v1/representatives/search?db=false&query=${query}`)
    .then(response => response.json())
    .then(data => {
      setRepData([...data])
    })
    .catch(error => console.log('error message: ', error.message))
  }

  return (
    <main className='App'>
      <Header />

      <div className='main-content'>
        <div className='searchbar-container'>
          <p>Search bar will go here.</p>
        </div>

        <div className='ticker-container'>
          <Ticker executiveOrders={executiveOrders}/>
        </div>
      </div>
      <Routes>
        {/* Routes will go here */}
      </Routes>
    </main>
  );
}

export default App
