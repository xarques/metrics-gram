class MediaController < ApplicationController
  include InstagramHelper
  skip_before_action :authenticate_user!, only: [:index, :search]
  def index
    @media = policy_scope(Medium)
    tags = params["query"]["tags"]
    if tags && tags.any?
      search_media_by_tag(tags[0])
    end
    locations = Location.where(city: params["query"]["city"])
    if params["query"]["keyword"]
      keyword = params["query"]["keyword"].downcase
    end
    if params["query"]["limit"]
      limit = params["query"]["limit"].to_i
    end
    if locations.any?
      @location = locations.first
      if limit
        media_by_location = search_media_by_location(@location.instagram_id, limit)
      else
        media_by_location = search_media_by_location(@location.instagram_id)
      end
      @media = []
      media_by_location.each do |medium|
        account = get_instagram_account_by_shortcode_media(medium.node.shortcode)
        if account && keyword && !keyword.empty?
          if account[:biography] && (account[:biography].downcase =~ /#{keyword}/)
            medium[:account] = account
            @media << medium
          end
        else
          @media << medium
        end
      end
    end
  end

  def search
    @locations = policy_scope(Location)
    # @media = policy_scope(Medium)
    # authorize Medium.new
  end

  private
  def set_medium
    @medium = Medium.find(params[:id])
    authorize @medium
  end

  def medium_params
    params.require(:medium).permit(:shortcode, :taken_at_timestamp, :display_url)
  end
end
