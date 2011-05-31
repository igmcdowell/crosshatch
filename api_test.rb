#TODO: request a URL to see if it's a redirect and keep re-requesting until it hits a page (or times out)
#replace matches with appropriate markup

require 'rubygems'
require 'twitter'
require 'oauth2'
require 'json'
require '../fbcreds'

def markupHashes! (text) 
  hashmatch = /\s#((?!.*-)[\w?!-]+)/
  text.gsub! hashmatch do 
    %Q|<a href="http://twitter.com/#!/search?q=%23#{$1}">##{$1}</a>| 
  end
end

def markupUsers! (text)
  usermatch = /\s@((?!.*-)[\w?!-]{1,15})/
  text.gsub! usermatch do
    %Q|<a href="http://twitter.com/#!/#{$1}">@#{$1}</a> |
  end
end

#client.request(:get, 'path')
def makefbclient
  OAuth2::Client.new(FBCreds::API_KEY, FBCreds::API_SECRET, :site => 'https://graph.facebook.com', :parse_json => true)
end



user = 'codywbratt'
sinceid = '74172195928154113'

ts = Twitter::Search.new.from(user).since_id(sinceid).fetch


urlmatch = /(http|https|ftp)\:\/\/([a-zA-Z0-9\.\-]+(\:[a-zA-Z0-9\.&amp;%\$\-]+)*@)*((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|localhost|([a-zA-Z0-9\-]+\.)*[a-zA-Z0-9\-]+\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{2}))(\:[0-9]+)*(\/($|[a-zA-Z0-9\.\,\?\'\\\+&amp;%\$#\=~_\-]+))*/

result = Net::HTTP.get(URI.parse('https://graph.facebook.com/19292868552'))

def rundemo
ts.each { |tweet| 
  if !tweet['to_user_id'] 
    text = tweet['text'] 
    markupHashes! text
    markupUsers! text
    puts text
  end
}
end