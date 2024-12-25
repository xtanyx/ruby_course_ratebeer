require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ) ]
    )
    allow(WeatherStackApi).to receive(:weather_of).with("kumpula").and_return(
      {"temperature"=>2, "weather_icons"=>[], "wind_speed"=>32, "wind_dir"=>"SW"}
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if many places are returned by the API, all are shown on the page" do
    places = [ Place.new(name: "Place1", id: 1), 
                Place.new(name: "Place2", id: 2), 
                Place.new(name: "Place2", id: 3), 
                Place.new(name: "Place3", id: 4),
                Place.new(name: "Place4", id: 5) ]

    allow(BeermappingApi).to receive(:places_in).with("testplace").and_return(places)
    allow(WeatherStackApi).to receive(:weather_of).with("testplace").and_return(
      {"temperature"=>2, "weather_icons"=>[], "wind_speed"=>32, "wind_dir"=>"SW"}
    )

    visit places_path
    fill_in('city', with: 'testplace')
    click_button "Search"

    places.each do |place|
      expect(page).to have_content(place.name)
    end
  end

  it "if no places are returned by the API, appropriate message is shown" do
    allow(BeermappingApi).to receive(:places_in).with("testplace").and_return([])
    allow(WeatherStackApi).to receive(:weather_of).with("testplace").and_return({})

    visit places_path
    fill_in('city', with: 'testplace')
    click_button "Search"

    expect(page).to have_content("No locations in testplace")
  end
end