module Helpers

  def sign_in(credentials)
    visit signin_path
    fill_in('username', with:credentials[:username])
    fill_in('password', with:credentials[:password])
    click_button('Log in')
  end
end

def create_beer_with_rating(object, score)
  if object[:style]
    beer = FactoryBot.create(:beer, style: object[:style])
  elsif object[:brewery]
    beer = FactoryBot.create(:beer, brewery: object[:brewery])
  else
    beer = FactoryBot.create(:beer)
  end

  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
  beer
end

def create_beers_with_many_ratings(object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end