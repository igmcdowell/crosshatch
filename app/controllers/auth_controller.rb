class AuthController < ApplicationController
  require 'net/http'
  require 'net/https'
  require 'oauth'
  
  def starttwitter
    oauth = OAuth::Consumer.new(ENV['TW_KEY'], ENV['TW_SECRET'],
                                 { :site => "https://twitter.com" })
    url = root_url + "auth/twitter"
    request_token = oauth.get_request_token(:oauth_callback => url)
    session[:twtoken] = request_token.token
    session[:twsecret] = request_token.secret
    redirect_to request_token.authorize_url
  end
  
  def finishtwitter
    oauth = OAuth::Consumer.new(ENV['TW_KEY'], ENV['TW_SECRET'],
                                 { :site => "http://twitter.com" })
    request_token = OAuth::RequestToken.new(oauth, session[:twtoken],
                                            session[:twsecret])
    access_token = request_token.get_access_token(
                      :auth_verifier => params[:oauth_verifier])


    @token = access_token.token            
    # Get account details from Twitter
    #@response = oauth.request(:get, '/account/verify_credentials.json',
                             access_token, { :scheme => :query_string })
    render :success
  end
  
  # GET /auth
  def validate
    if params[:code]
      path = %Q|https://graph.facebook.com/oauth/access_token?code=#{params[:code]}&client_id=#{ENV['FB_ID']}&client_secret=#{ENV['FB_SECRET']}&redirect_uri=#{root_url+'auth'}|
      uri = URI.parse(path)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      r = Net::HTTP::Get.new(uri.request_uri)
      @response = http.request(r)
      begin
        data = JSON.parse(@response.body)
      rescue JSON::ParserError
        exp = /token=(.*)/
        exp.match(@response.body)
        if $1
          @token = $1
        else
          @error = "Non-json response, but not a token"
        end
      end
      if @token
        #@twitter_id = data['twitter_id']
        render :success
      else
        if !@error
          @error = data['error']['type']
        end
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
