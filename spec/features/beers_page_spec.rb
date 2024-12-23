require 'rails_helper'

include Helpers

describe "Beer" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  
  before :each do
    FactoryBot.create :user
    sign_in(username: "Pekka", password: "Foobar1")
    visit beers_path
  end

  it "is created successfully when the name is correct" do
    click_link "New Beer"
    fill_in('beer_name', with: 'testbeer')
    select('Lager', from: 'beer[style]')
    select('Koff', from: 'beer[brewery_id]')
    click_button "Create Beer"

    expect(current_path).to eq(beers_path)
    expect(page).to have_content("Beer was successfully created.")
    expect(page).to have_content("testbeer")
    expect(page).to have_content("Koff")
    expect(Beer.count).to eq(1)
  end

  it "is not created and appropriate error message is displayed if beer name is not valid" do
    click_link "New Beer"
    fill_in('beer_name', with: '')
    select('Lager', from: 'beer[style]')
    select('Koff', from: 'beer[brewery_id]')
    click_button "Create Beer"

    expect(page).to have_content("New beer")
    expect(page).to have_content("Name can't be blank")
    expect(Beer.count).to eq(0)
  end
end