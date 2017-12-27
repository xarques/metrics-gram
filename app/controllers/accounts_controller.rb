class AccountsController < ApplicationController
  include InstagramHelper
  skip_before_action :authenticate_user!, only: [:index, :search]

  def index
    @accounts = policy_scope(Medium)
    locations = Location.where(city: params["query"]["city"])
    if params["query"]["keyword"]
      keyword = params["query"]["keyword"].downcase
    end
    if params["query"]["limit"]
      limit = params["query"]["limit"].to_i
    end
    if locations.any?
      @location = locations.first
      @accounts = search_account_by_location_and_keyword(@location.instagram_id, keyword, limit)
    end
  end

  def search
    @locations = policy_scope(Location)
    # @media = policy_scope(Medium)
    # authorize Medium.new
  end

  private
  def set_account
    @account = Account.find(params[:id])
    authorize @account
  end

  def account_params
    params.require(:account).permit()
  end
end
