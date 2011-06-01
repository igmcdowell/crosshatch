class SetupController < ApplicationController
  def show
    @twitter_login = root_url + 'auth/starttwitter'
    @fb_login = %Q|https://graph.facebook.com/oauth/access_token?code=#{params[:code]}&client_id=#{ENV['FB_ID']}&client_secret=#{ENV['FB_SECRET']}&redirect_uri=#{root_url+'auth'}|
    render :index
  end
end