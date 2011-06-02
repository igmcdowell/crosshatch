class HatcherController < ApplicationController
  user = Users.find_by_tw_id('182253036') #hardcoding for initial testing.
  Twitter.configure do |config|
    config.consumer_key = ENV['TW_KEY']
    config.consumer_secret = ENV['TW_SECRET']
    config.oauth_token = user['tw_token']
    config.oauth_token_secret = user['tw_secret']
  end
  client = Twitter::Client.new
  timeline = client.user_timeline({:since_id => user['last_post'], :include_entities => true})
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
    end
end