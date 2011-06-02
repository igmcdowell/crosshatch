class HatcherController < ApplicationController
  def hatch
    user = User.find_by_tw_id('182253036') #hardcoding for initial testing.
    Twitter.configure do |config|
      config.consumer_key = ENV['TW_KEY']
      config.consumer_secret = ENV['TW_SECRET']
      config.oauth_token = user['tw_token']
      config.oauth_token_secret = user['tw_secret']
    end
    client = Twitter::Client.new
    timeline = client.user_timeline({:since_id => user['last_post'], :include_entities => true})
    if timeline[0]
      user['last_post'] = timeline[0]['id']
      user.save
    end
    timeline.each do |tweet|
      if !tweet['to_user_id'] 
        text = tweet['text'] 
        entities = tweet['entities']
        hashtags = entities['hashtags']
        mentions = entities['user_mentions']
        mentions.each do |mention| #I include the leading @ to guard against really bad double encoding
          text.gsub!('@'+mention['screen_name'],'@'+mention['screen_name']+' (http://t3l.us/'+mention['screen_name']+')')
        end
        hashtags.each do |tag|
          text.gsub!('#'+tag['text'],'#'+tag['text']+' (http://t3l.us/h/'+tag['text']+')')
        end
        puts text
        
        
        path = "https://graph.facebook.com/me/feed"
        uri = URI.parse(path+'?access_token='+CGI.escape(token))
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        @response = http.request_post(uri.path+'?'+uri.query, 'message='+text)
      end
    end
    render :index
  end
end