require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "is not created when it is wrong" do
    visit new_rating_path
    select('iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '60')

    expect{
      click_button "Create Rating"
    }.to_not change{Rating.count}
    expect(page).to have_content("Create new rating")

  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "after given, is displayed on the ratings page along with the total number" do
    FactoryBot.create(:rating, score: 10, beer: beer1, user: user)
    FactoryBot.create(:rating, score: 12, beer: beer2, user: user)
    FactoryBot.create(:rating, score: 14, beer: beer2, user: user)
    FactoryBot.create(:rating, score: 8, beer: beer1, user: user)
    FactoryBot.create(:rating, score: 19, beer: beer1, user: user)

    visit ratings_path

    expect(page).to have_content("Number of ratings: #{Rating.count}")
    Rating.all.each do |rating|
      expect(page).to have_content("#{rating.beer.name} #{rating.score}")
    end
  end
end