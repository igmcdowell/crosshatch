class User < ActiveRecord::Base
  def addTwitterToken(t, s)
    self[:tw_linked] = true
    self[:tw_token] = t
    self[:tw_secret] = s
    self.save
  end
  
  def addFBToken(t)
    self[:fb_token] = t
    self[:fb_linked] = true
    self.save
  end
  
  def updateInfo(name, picture)
    self[:tw_handle] = name
    self[:tw_img] = picture
    self.save
  end
  
  def createTwitterClient
    Twitter.configure do |config|
      config.consumer_key = ENV['TW_KEY']
      config.consumer_secret = ENV['TW_SECRET']
      config.oauth_token = self[:tw_token]
      config.oauth_token_secret = self[:tw_secret]
    end
    client = Twitter::Client.new
    #returned implicitly
  end
  
  def getTwitterTimeline(client)
    timeline = client.user_timeline({:since_id => self[:last_post], :include_entities => true})
    return timeline
  end
  
  def postToFB(tweet)
    skip = false
    if !tweet['to_user_id'] 
      text = tweet['text'] 
      entities = tweet['entities']
      hashtags = entities['hashtags']
      mentions = entities['user_mentions']
      mentions.each do |mention| 
        #I include the leading @ to guard against really bad double encoding
        text.gsub!('@'+mention['screen_name'],'@'+mention['screen_name']+' (http://t3l.us/'+mention['screen_name']+')')
        if mention['indices'][0] == 0 
          skip = true
        end
      end
      if !skip
        hashtags.each do |tag|
          text.gsub!('#'+tag['text'],'#'+tag['text']+' (http://t3l.us/h/'+tag['text']+')')
        end
        path = "https://graph.facebook.com/me/feed"
        uri = URI.parse(path+'?access_token='+CGI.escape(self[:fbtoken]))
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        @response = http.request_post(uri.path+'?'+uri.query, 'message='+text)
        @body = response.body
      end
    end
  end
  
  def hatchTweets
    client = self.createTwitterClient
    timeline = self.getTwitterTimeline(client)
    if timeline[0]
      #we log the last post before actually posting to FB. This trades accidentally not posting for accidentally double posting if errors happen.
      self[:last_post] = timeline[0]['id'] 
      self.save
    end
    timeline.each do |tweet|
      self.postToFB(tweet)
    end
  end
  
end
