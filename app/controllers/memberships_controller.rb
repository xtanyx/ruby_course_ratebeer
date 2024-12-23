class MembershipsController < ApplicationController
  def index
    @memberships = Membership.all
  end

  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all.filter {|club| not current_user.beer_clubs.include? club}
  end

  def create
    @membership = Membership.create params.require(:membership).permit(:beer_club_id)
    @membership.user = current_user

    if @membership.save
      redirect_to memberships_path
    else
      @beer_clubs = BeerClub.all.filter {|club| current_user.beer_clubs.include? club}
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    membership = Membership.find(params[:id])
    membership.delete
    redirect_to memberships_path
  end
end
