module InstagramHelper
  # require 'open-uri'
  # require 'nokogiri'

  # ingredient = 'chocolate'
  # url = "https://www.instagram.com/p/Bb18e3hFLpi"

  # html_file = open(url).read
  # html_doc = Nokogiri::HTML(html_file)

  # puts html_doc
  # html_doc.search('._ezgzd a').each do |element|
  #   puts element
  #   puts element.text.strip
  #   puts element.attribute('href').value
  # end

  require 'mechanize'
  require 'json'
  require 'net/http'
  require 'recursive-open-struct'

  INSTAGRAM_URL = 'https://www.instagram.com'

  MEDIA_TO_COMMENT_QUERY_ID = '17852405266163336'
  # https://www.instagram.com/graphql/query/?query_id=17852405266163336&variables={"shortcode":"BYdxJbMF-NP","first":150}LIKED_BY_QUERY_ID = '17864450716183058'
  OWNER_TO_TIMELINE_MEDIA_QUERY_ID = '17888483320059182'
  # https://www.instagram.com/graphql/query/?query_id=17888483320059182&variables={"id":"695045035","first":12}
  LIKED_BY_QUERY_ID = '17864450716183058'
  # https://www.instagram.com/graphql/query/?query_id=17864450716183058&variables={"shortcode":"BcnGn0MFnmt","first":40}
  FOLLOWED_BY_QUERY_ID = '17851374694183129'
  # https://www.instagram.com/graphql/query/?query_id=17851374694183129&variables={"id":"695045035","first":20}
  FOLLOW_QUERY_ID = '17874545323001329'
  # https://www.instagram.com/graphql/query/?query_id=17874545323001329&variables={"id":"695045035","first":20}
  WEB_DISCOVER_MEDIA_QUERY_ID = '17863787143139595'
  # https://www.instagram.com/graphql/query/?query_id=17863787143139595&variables={"first":24}
  FACEBOOK_FRIENDS_AND_SUGGESTED_USER_QUERY_ID = '17847560125201451'
  # https://www.instagram.com/graphql/query/?query_id=17847560125201451&variables={"fetch_media_count":0,"fetch_suggested_count":20,"ignore_cache":true,"filter_followed_friends":true,"seen_ids":[]}
  LOCATION_TO_MEDIA_QUERY_ID = '17865274345132052'
  # Paris
  # https://www.instagram.com/graphql/query/?query_id=17865274345132052&variables={"id":"6889842","first":12,"after":"1674206472837028819"}
  # New York
  # https://www.instagram.com/graphql/query/?query_id=17865274345132052&variables={"id":"212988663","first":12,"after":"1674222760409149768"}
  # ADRELANINE_ID = '3041781563'
  CHAINING_QUERY_ID = '17845312237175864'
  # https://www.instagram.com/graphql/query/?query_id=17845312237175864&variables={"id":"3041781563"}
  WEB_FEED_TIMELINE_QUERY_ID = '17842794232208280'
  # https://www.instagram.com/graphql/query/?query_id=17842794232208280&variables={"fetch_media_item_count":12,"fetch_media_item_cursor":"KGEAgjAHZmcsNBcIpYVa1hU0F0qgBRflBCcXErOHudcWNBcZDAbUwIgjF58jhiMtvDsXoBKER1TAKRdkboZB_is0F2gEhnqKJScX83OG8_kPIhd19cCyeEAAAD1zBT9bBScXFoilqtyOWCoUBAA=","fetch_comment_count":4,"fetch_like":10,"has_stories":false}
  MAX_NUMBER_OF_TIMELINES = 5
  MAX_NUMBER_OF_COMMENTS = 5
  MAX_NUMBER_OF_LIKES = 5
  MAX_NUMBER_OF_MEDIA = 10
  MAX_NUMBER_OF_ACCOUNTS = 10
  # QUERY_URL = "\"https://www.instagram.com/graphql/query/?query_id=#{query_id}&variables={\"shortcode\":\"#{shortcode}\",\"first\":10}\""
  # https://www.instagram.com/graphql/query/?query_id=17888483320059182&variables=%7B%22id%22%3A%223041781563%22%2C%22first%22%3A12%2C%22after%22%3A%22AQCNCnVfNu1IYxbaJLQAjflo1WnjuRYTbS2pJ05cyzMMwHg7O_9Pc80PRNqpnwfYIpSmHx9xT5vB2EE9yUCc6x9W27qKLlKfDsqiL0eq12AuiQ%22%7D
  # def parse_html(url)
  #   agent = Mechanize.new
  #   page = agent.get(url)
  #   match = agent.page.search("script").text.scan(/\{"activity_counts".*true\}/)
  #   instagram_object = JSON.parse(match[0]);
  #   post_pages = instagram_object["entry_data"]["PostPage"]
  #   post_pages.each do |post_page|
  #     parse_data(post_page["graphql"])
  #   end
  HASHTAG_QUERY_ID = '17886322183179102'
  # https://www.instagram.com/graphql/query/?query_id=17886322183179102&variables={"tag_name":"urbex","first":5}
  SUGGESTED_USERS_QUERY_ID = '17847560125201451'
  # https://www.instagram.com/graphql/query/?query_id=17847560125201451&variables={%22fetch_media_count%22:0,%22fetch_suggested_count%22:20,%22ignore_cache%22:false,%22filter_followed_friends%22:true,%22seen_ids%22:[%22242903682%22,%221720416472%22,%2226669533%22,%22189393625%22,%22460563723%22,%221599570543%22,%22363329733%22,%221510284329%22,%2225025320%22,%221963045040%22,%22244520920%22,%2215111621%22,%22206851755%22,%22181712705%22,%22247944034%22,%228630260%22,%22186901415%22,%22179444312%22,%22220231255%22,%221387660581%22,%221809062259%22,%22397934240%22,%22671139752%22,%221282864537%22,%222030900651%22,%22349733985%22,%22406481723%22,%22201482203%22,%22640806256%22,%22299323636%22,%22270739417%22,%22263110431%22,%223503951%22,%2211830955%22,%22227497518%22,%22354360218%22,%221743025989%22,%22414062878%22,%22376027101%22,%221329154464%22]}

  # def get_entry_data(url)
  #   begin
  #     agent = Mechanize.new
  #     page = agent.get(url)
  #     match = agent.page.search("script").text.scan(/\{"activity_counts".*true\}/)
  #     instagram_object = JSON.parse(match[0]);
  #     openstruct_obj = RecursiveOpenStruct.new(instagram_object, recurse_over_arrays: true )
  #     return openstruct_obj.entry_data
  #   rescue
  #     return nil
  #   end
  # end

  # def get_instagram_account_by_shortcode_media0(shortcode_media)
  #   entry_data = get_entry_data("#{INSTAGRAM_URL}/p/#{shortcode_media}")
  #   if entry_data
  #     owner = get_instagram_account(entry_data.PostPage[0].graphql.shortcode_media.owner)
  #     # No bio available. Research account by name to retrieve the bio
  #     return get_instagram_account_by_name(owner[:username])
  #   else
  #     return nil
  #   end
  # end

  def get_instagram_account_by_shortcode_media(shortcode_media)
    query = "#{INSTAGRAM_URL}/p/#{shortcode_media}/?__a=1"
    puts ("get_instagram_account_by_shortcode_media(#{shortcode_media}) query = #{query}")
    openstruct_obj = get_graphql_data(query, "graphql")
    # puts ("get_instagram_account_by_shortcode_media(#{shortcode_media}) openstruct_obj = #{openstruct_obj}")
    if openstruct_obj
      owner = get_instagram_account(openstruct_obj.shortcode_media.owner)
      return get_instagram_account_by_name(owner[:username])
    else
      return nil
    end
  end

  # def get_instagram_account_by_name0(name)
  #   entry_data = get_entry_data("#{INSTAGRAM_URL}/#{name}")
  #   if entry_data
  #     return get_instagram_account(entry_data.ProfilePage[0].user)
  #   else
  #     return nil
  #   end
  # end

  def get_average_of_likes_by_username(name)
    account = get_instagram_account_by_name(name)
    media = account.media.nodes
    total_likes = 0
    media.each do |medium|
      total_likes += medium.likes.count
    end
    return total_likes / media.size
  end

  def get_instagram_account_by_name(name)
    query = "#{INSTAGRAM_URL}/#{name}/?__a=1"
    puts ("get_instagram_account_by_name(#{name}) query = #{query}")
    openstruct_obj = get_graphql_data(query, "user")
    if openstruct_obj
      return get_instagram_account(openstruct_obj)
    else
      return nil
    end
  end

  def get_instagram_account(user)
    instagram_user = user
    # instagram_user = {
    #   id: user.id,
    #   username: user.username,
    #   full_name: user.full_name,
    #   biography: user.biography
    # }
    puts ("user #{instagram_user[:username]} aka #{instagram_user[:full_name]} has Instagram id #{instagram_user[:id]}")
    puts ("Bio: #{instagram_user[:biography]}")
    return instagram_user
  end

  def get_graphql_data(url, object_name="data")
    begin
      uri = URI(url)
      response = Net::HTTP.get(uri)
      response_json = JSON.parse(response)
      return RecursiveOpenStruct.new(response_json[object_name], recurse_over_arrays: true )
    rescue
      return nil
    end
  end

  def search_media_by_location_and_keyword(location_id, keyword, limit=MAX_NUMBER_OF_MEDIA)
    media_by_location = search_media_by_location(location_id, limit)
    media = []
    media_by_location.each do |medium|
      account = get_instagram_account_by_shortcode_media(medium.node.shortcode)
      if account && keyword && !keyword.empty?
        if account[:biography] && (account[:biography].downcase =~ /#{keyword}/)
          medium[:account] = account
          media << medium
        end
      else
        media << medium
      end
    end
    return media
  end

  def search_account_by_location_and_keyword(location_id, keyword, limit=MAX_NUMBER_OF_ACCOUNTS)
    media_by_location = search_media_by_location(location_id, limit)
    accounts = []
    media_by_location.each do |medium|
      account = get_instagram_account_by_shortcode_media(medium.node.shortcode)
      if account && keyword && !keyword.empty?
        if account[:biography] && (account[:biography].downcase =~ /#{keyword}/)
          accounts << account
          puts("Keyword #{keyword} found in bio of #{account.username}")
        else
          puts("Keyword #{keyword} not found in bio of #{account.username}")
        end
      end
    end
    return accounts
  end

  def search_media_by_location(location_id, limit=MAX_NUMBER_OF_MEDIA)
    query = "https://www.instagram.com/graphql/query/?query_id=#{LOCATION_TO_MEDIA_QUERY_ID}&variables={\"id\":\"#{location_id}\",\"first\":#{limit}}"
    puts ("search_media_by_location query = #{query}")
    openstruct_obj = get_graphql_data(query)
    parse_media(openstruct_obj)
  end

  def parse_media(data)
    if data
      location = data.location
      if location
        count = location.edge_location_to_media.count
        edges = location.edge_location_to_media.edges
        puts ("Number of media available on this page: #{edges.size}/#{count}")
        return edges
      end
    end
    puts ("No media")
    return nil
  end


  def search_media_by_tags(tags, limit=MAX_NUMBER_OF_MEDIA)
    _search_media_by_tags(tags, "edge_hashtag_to_media", limit)
  end

  def search_top_posts_media_by_tags(tags, limit=MAX_NUMBER_OF_MEDIA)
    _search_media_by_tags(tags, "edge_hashtag_to_top_posts", limit)
  end

  def _search_media_by_tags(tags, edge_name, limit=MAX_NUMBER_OF_MEDIA)
    query = "https://www.instagram.com/graphql/query/?query_id=#{HASHTAG_QUERY_ID}&variables={\"tag_name\":\"#{tags[0]}\",\"first\":#{limit}}"
    puts ("search_media_by_tag #{edge_name} query = #{query}")
    openstruct_obj = get_graphql_data(query)
    parse_media_by_tags(openstruct_obj, tags, edge_name)
  end

  def parse_media_by_tags(data, tags, edge_name)
    if data
      hashtag = data.hashtag
      edges_by_tags = []
      if hashtag
        count = hashtag[edge_name].count
        edges = hashtag[edge_name].edges
        total_likes = 0
        number_of_edges_found = 0
        puts ("Number of media available on this page: #{edges.size}/#{count}")
        edges.each do |edge|
          begin
            media_to_caption_text = edge.node.edge_media_to_caption.edges[0].node.text
            # puts("media_to_caption_text= #{media_to_caption_text}")
            all_tags = true
            # Revome first tag of tags as it as already been taken into account for the first query
            tags.pop
            tags.each do |tag|
              if media_to_caption_text.downcase =~ /##{tag.downcase}/
                puts "Media #{edge.node.shortcode} contains tag #{tag.downcase}"
              else
                puts "Media #{edge.node.shortcode} does not contain tag #{tag.downcase}"
                all_tags = false
              end
            end
            if all_tags
              number_of_edges_found += 1
              edges_by_tags << edge
              total_likes += edge.node.edge_liked_by.count
            end
          rescue

          end
        end
        # puts("edges_by_tags = #{edges_by_tags}")
        return {
          edges_by_tags: edges_by_tags,
          likes_average: total_likes / number_of_edges_found
        }
      end
    end
    puts ("No media")
    return nil
  end

  def group_comments(shortcode, comments)
    query = "https://www.instagram.com/graphql/query/?query_id=#{MEDIA_TO_COMMENT_QUERY_ID}&variables={\"shortcode\":\"#{shortcode}\",\"first\":#{MAX_NUMBER_OF_COMMENTS}}"
    openstruct_obj = get_graphql_data(query)
    return parse_comments(openstruct_obj, comments)
  end

  def parse_comments(data, comments)
    if data
      shortcode_media = data.shortcode_media
      if shortcode_media
        count = shortcode_media.edge_media_to_comment.count
        edges = shortcode_media.edge_media_to_comment.edges

        puts ("Number of comments available on this page: #{edges.size}/#{count}")
        return parse_edges(edges, comments)
      end
    end
    puts ("No media")
    return nil
  end

  def group_likes(shortcode, likes)
    query = "https://www.instagram.com/graphql/query/?query_id=#{LIKED_BY_QUERY_ID}&variables={\"shortcode\":\"#{shortcode}\",\"first\":#{MAX_NUMBER_OF_LIKES}}"
    openstruct_obj = get_graphql_data(query)
    return parse_likes(openstruct_obj, likes)
  end

  def parse_likes(data, likes)
    if data
      shortcode_media = data.shortcode_media
      if shortcode_media
        count = shortcode_media.edge_liked_by.count
        edges = shortcode_media.edge_liked_by.edges

        puts ("Number of likes available on this page: #{edges.size}/#{count}")
        return parse_edges(edges, likes)
      end
    end
    puts ("No media")
    return nil
  end

  def parse_edges(edges, array)
    edges.each do |edge|
      node = edge.node
      user = node.username
      if !user
        user = node.owner.username
      end
      if !array[user]
        array[user] = []
      end
      array[user] << node
    end
    return array
  end

  def parse_timeline(data)
    if data
      edge_owner_to_timeline_media = data.user.edge_owner_to_timeline_media
      if edge_owner_to_timeline_media
        count = edge_owner_to_timeline_media.count
        edges = edge_owner_to_timeline_media.edges

        puts ("Number of timeline available on this page: #{edges.size}/#{count}")
        return parse_edges_timeline(edges)
      end
    end
    puts ("No media")
    return nil
  end

  def parse_edges_timeline(edges)
    timelines = []
    edges.each do |edge|
      node = edge.node
      shortcode = node.shortcode
      timelines << shortcode
    end
    return timelines
  end

  # parse_html('https://www.instagram.com/p/Bb18e3hFLpi')
  # parse_html('https://www.instagram.com/p/BYdxJbMF-NP')

  # users_comments = parse_graphql('https://www.instagram.com/graphql/query/?query_id=17852405266163336&variables={"shortcode":"BYdxJbMF-NP","first":150}')
  # users_comments = parse_graphql('https://www.instagram.com/graphql/query/?query_id=17852405266163336&variables={"shortcode":"Bb18e3hFLpi","first":150}')
  # users_comments = parse_graphql('https://www.instagram.com/graphql/query/?query_id=17852405266163336&variables={"shortcode":"Bb18e3hFLpi","first":150}')

  def analyze_comments(comments)
    # Sort in reverse order of comment's count
    sorted_users_comments = comments.sort_by do |user_comments_key, user_comments_node|
      - user_comments_node.size
    end

    sorted_users_comments.each do |user_comments_key, user_comments_value|
      puts ("User #{user_comments_key} did #{user_comments_value.size} comment(s) ")
    end
  end

  def analyze_likes(likes)
    # Sort in reverse order of comment's count
    sorted_users_likes = likes.sort_by do |user_likes_key, user_likes_node|
      - user_likes_node.size
    end

    sorted_users_likes.each do |user_likes_key, user_likes_value|
      puts ("User #{user_likes_key} did #{user_likes_value.size} like(s) ")
    end
  end

  def analyze_instagram_account(account)
    account_id = account[:id]
    comments = {}
    likes = {}
    timeline_query = "https://www.instagram.com/graphql/query/?query_id=#{OWNER_TO_TIMELINE_MEDIA_QUERY_ID}&variables={\"id\":\"#{account_id}\",\"first\":#{MAX_NUMBER_OF_TIMELINES}}"
    puts ("Perform query #{timeline_query}")
    timeline_obj = get_graphql_data(timeline_query)
    shortcodes = parse_timeline(timeline_obj)
    shortcodes.each do |shortcode|
      group_comments(shortcode, comments)
      group_likes(shortcode, likes)
      sleep([2,3,4,5,6].sample)
    end
    analyze_comments(comments)
    analyze_likes(likes)
  end

  # analyze_instagram_account(get_instagram_user("laouate12"))
  # analyze_instagram_account(get_instagram_account_by_name("adrelanine"))

  #media = search_media_by_location(6889842)
  #puts media

  # get_instagram_account("adrelanine")
  # parse_graphql('https://www.instagram.com/graphql/query/?query_id=17852405266163336&variables={"shortcode":"Bb18e3hFLpi","first":150}')
end
