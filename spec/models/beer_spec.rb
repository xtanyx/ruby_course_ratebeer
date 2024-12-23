require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "is saved with proper name, style and brewery" do
    test_brewery = Brewery.create name: "testbrewery", year: 2001
    test_beer = Beer.create name: "testbeer", style: "teststyle", brewery: test_brewery

    expect(test_beer.valid?).to be(true)
    expect(Beer.count).to eq(1)
  end

  it "is not saved when no name is provided" do
    test_brewery = Brewery.create name: "testbrewery", year: 2001
    test_beer = Beer.create style: "teststyle", brewery: test_brewery

    expect(test_beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

  it "is not saved when no style is provided" do
    test_brewery = Brewery.create name: "testbrewery", year: 2021
    test_beer = Beer.create name: "testbeer", brewery: test_brewery

    expect(test_beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end
end
