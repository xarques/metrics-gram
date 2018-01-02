class MediaController < ApplicationController
  include InstagramHelper
  # skip_before_action :authenticate_user!, only: [:index_by_tag, :search, :search_by_tag]

  def index_by_tag
    @media = policy_scope(Medium)
    authorize Medium.new
    tags = params["query"]["tags"]
    if params["query"]["limit"]
      limit = params["query"]["limit"].to_i
    end
    if tags && tags.any?
      @tags_array = tags[0].split(',')
      puts("tags == #{@tags_array}")
      top_posts = params["query"]["top_posts"]
      one_by_one = params["query"]["one_by_one"]
      if one_by_one && one_by_one == "0"
        if top_posts && top_posts == "1"
          @media = search_top_posts_media_by_tags(@tags_array, limit)
        else
          @media = search_media_by_tags(@tags_array, limit)
        end
        @user_averages = get_average_of_engagement_by_username(current_user.username)
        render :index_by_tag
      else
        @media_group_by_hashtag = sort_top_posts_media_for_each_tag_by_engagement_ratio(@tags_array, current_user.username)
        render :index_by_tags
      end
    end
  end

  def search_by_tag
    @locations = policy_scope(Location)
    # @media = policy_scope(Medium)
    authorize Medium.new
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
