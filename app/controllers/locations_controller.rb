class LocationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def index
    @locations = policy_scope(Location)
  end

  private
  def set_location
    @location = Location.find(params[:id])
    authorize @location
  end

  def location_params
    params.require(:location).permit(:city, :instagram_id)
  end
end
