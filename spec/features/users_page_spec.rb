require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    @user = FactoryBot.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with: 'Brian')
      fill_in('user_password', with: 'Secret55')
      fill_in('user_password_confirmation', with: 'Secret55')
    
      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end

    it "can only see their own rating on the individual user page" do
      user_2 = FactoryBot.create(:user, username: "beep", password: "Beep1", password_confirmation: "Beep1")

      create_beers_with_many_ratings({user: user_2}, 10, 12, 7, 10)
      create_beers_with_many_ratings({user: @user}, 17, 11, 8, 19, 15)

      sign_in(username: "Pekka", password: "Foobar1")

      visit user_path(@user)

      expect(Rating.count).to eq(9)
      expect(Rating.count).to_not eq(@user.ratings.count)
      expect(page).to have_content("Has made #{@user.ratings.count} ratings")
      @user.ratings.each do |rating|
        expect(page).to have_content("#{rating.beer.name} #{rating.score} Delete")
      end
      user_2.ratings.each do |rating|
        expect(page).to_not have_content("#{rating.beer.name} #{rating.score} Delete")
      end
    end

    it "can delete their rating and the rating is deleted from database" do
      create_beers_with_many_ratings({user: @user}, 17, 11, 8, 19, 15)

      sign_in(username: "Pekka", password: "Foobar1")

      visit user_path(@user)

      expect(@user.ratings.count).to eq(5)

      page.find('li', text: 'anonymous 17').click_link('Delete')

      expect(Rating.count).to eq(4)
      expect(@user.ratings.count).to eq(4)
      expect(page).to_not have_content('anonymous 17')
    end

    it "has the correct favorite style displayed" do
      create_beers_with_many_ratings({user: @user, style: "Pale ale"}, 10, 15, 17)
      create_beers_with_many_ratings({user: @user}, 12, 15, 10)
      create_beers_with_many_ratings({user: @user, style: "IPA"}, 20, 19, 18)

      visit user_path(@user)

      expect(page).to have_content("Favorite style: IPA")
    end

    it "has the correct favorite brewery displayed" do
      create_beers_with_many_ratings({user: @user}, 12, 15, 10)
      b1 = FactoryBot.create(:brewery, name: "testb1", year: 2020)
      b2 = FactoryBot.create(:brewery, name: "testb2", year: 1976)
      create_beers_with_many_ratings({user: @user, brewery: b1}, 12, 15, 17, 8)
      create_beers_with_many_ratings({user: @user, brewery: b2}, 20, 15, 10, 19, 18)

      visit user_path(@user)

      expect(page).to have_content("Favorite brewery: #{b2.name}")
    end

    it "logs out, they are redirected to root page and their session is destroyed" do
      sign_in(username: "Pekka", password: "Foobar1")
      
      click_link("Sign Out")

      expect(page.current_path).to eq(root_path)
    end
  end
end