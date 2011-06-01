class AuthController < ApplicationController
  require 'net/http'
  require 'net/https'
  # GET /auth
  def validate
    if params[:code]
      path = %Q|https://graph.facebook.com/oauth/access_token?client_id=#{ENV['FB_ID']}&redirect_uri=#{root_url+'/auth?gotcode'}&client_secret=#{ENV['FB_SECRET']}&code=#{params[:code]}|
      uri = URI.parse(path)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      r = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(r)
      data = JSON.parse(response.body)
      if data['access_token']
        @token = data['access_token'] 
        @twitter_id = data['twitter_id']
        render :success
      else
        @error = data['error']['type']
        @error_description = data['error']['message']
        @token = "error, no token"
        render :error
      end
    else
      if params[:error] 
        @error_reason = params[:error_reason]
        @error = params[:error]
        @error_description = params[:error_description]
      else
        @error = 'No Authentication Code or Facebook Error'
        @error_reason = 'You may have accessed this URL directly.'
        @error_description = 'Please try to reauthenticate using Facebook.'
      end
      render :error
    end
  end
end
