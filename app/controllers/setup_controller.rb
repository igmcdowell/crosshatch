class SetupController < ApplicationController
  def show
    @twitter_login = root_url + 'auth/starttwitter'
    @fb_login = %Q|https://www.facebook.com/dialog/oauth?client_id=#{ENV['FB_ID']}&redirect_uri=#{root_url+'auth'}&scope=publish_stream,offline_access|
    render :index
  end
end