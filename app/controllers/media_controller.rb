class MediaController < ApplicationController
  include InstagramHelper
  skip_before_action :authenticate_user!, only: [:index_by_tag, :search, :search_by_tag]

  def index_by_tag
    @media = policy_scope(Medium)
    tags = params["query"]["tags"]
    if tags && tags.any?
      puts("tags == #{tags[0].split(',')}")
      @media = search_media_by_tags(tags[0].split(','))
    end
  end

  def search_by_tag
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
