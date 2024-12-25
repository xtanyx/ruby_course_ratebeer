class MembershipsController < ApplicationController
  def index
    @memberships = Membership.all
  end

  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all.filter { |club| !current_user.beer_clubs.include? club }
  end

  def create
    @membership = Membership.create membership_params
    @membership.user = current_user

    if @membership.save
      redirect_to beer_club_path(:beer_club_id), notice: "#{current_user.username} welcome to the club."
    else
      @beer_clubs = BeerClub.all.filter { |club| current_user.beer_clubs.include? club }
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    membership = Membership.find(membership_params[:membership_id])
    club = BeerClub.find(membership_params[:beer_club_id])
    membership.delete
    redirect_to current_user, notice: "Membership in #{club.name} ended."
  end

  private

  def membership_params
    params.require(:membership).permit(:membership_id, :beer_club_id)
  end
end
