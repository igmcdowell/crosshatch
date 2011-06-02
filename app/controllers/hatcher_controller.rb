class HatcherController < ApplicationController
  user = Users.find_by_twitter_id
  Twitter.configure do |config|
    config.consumer_key = ENV['TW_KEY']
    config.consumer_secret = ENV['TW_SECRET']
    config.oauth_token = 
    config.oauth_token_secret = 
  end
end