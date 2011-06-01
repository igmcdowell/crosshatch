class CanvasController < ApplicationController
  require 'net/http'
  require 'net/https'
  # GET /auth
  def signup
   @add = %Q|https://www.facebook.com/dialog/oauth?client_id=#{ENV['FB_ID']}&redirect_uri=#{root_url+'auth'}&scope=publish_stream,offline_access|
   render :signup
  end
end
