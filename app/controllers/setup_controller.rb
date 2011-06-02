class SetupController < ApplicationController
  def show
    if(session[:twid])
      user = User.find_by_tw_id(session[:twid])
      @twitter_login = root_url + 'auth/starttwitter'
      @fb_login = %Q|https://www.facebook.com/dialog/oauth?client_id=#{ENV['FB_ID']}&redirect_uri=#{root_url+'auth'}&scope=publish_stream,offline_access|
      if user[:tw_linked]
        @twitter_linked = true
      end
      render :index
    else
      redirect_to root_url
    end
  end
end