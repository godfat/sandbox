
api_key = '...'
secret  = '...'
session_key    = 'oa-oauth.linkedin'
session_secret = '...'

gem 'nokogiri' , '~>1.4.4'
gem 'multi_xml', '~>0.2.2'
gem 'oa-oauth' , '~>0.2.5'

require 'nokogiri'
require 'multi_xml'
require 'omniauth/oauth'

module OmniAuth # fix oa-auth for linked_in, user_hash is totally broken
  module Strategies
    class LinkedIn < OmniAuth::Strategies::OAuth
      def user_hash(access_token)
       person = MultiXml.parse(@access_token.get('/v1/people/~:(id,first-name,last-name,headline,member-url-resources,picture-url,location,public-profile-url)').body)['person']

        hash = {
          'id' => person['id'],
          'first_name' => person['first_name'],
          'last_name' => person['last_name'],
          'nickname' => person['public_profile_url'].split('/').last,
          'location' => person['location']['name'],
          'image' => person['picture_url'],
          'description' => person['headline'],
          'public_profile_url' => person['public_profile_url']
        }
        hash['urls']={}
        member_urls = person['member_url_resources']['member_url']
        if (!member_urls.nil?) and (!member_urls.empty?)
          [member_urls].flatten.each do |url|
            hash['urls']["#{url['name']}"]=url['url']
          end
        end
        hash['urls']['LinkedIn'] = person['public_profile_url']
        hash['name'] = "#{hash['first_name']} #{hash['last_name']}"
        hash
      end
    end
  end
end

require 'pp'
require 'cgi'

use Rack::ContentLength
use Rack::ContentType, 'text/plain'

use Rack::Session::Cookie,
  :key    => session_key,
  :secret => session_secret

use OmniAuth::Builder do
  provider :linked_in, api_key, secret,
     :request_path => '/auth/linkedin',
    :callback_path => '/main' # / didn't work?
end

run lambda{ |env|
  if env['omniauth.auth'].nil?
    # 404 is required, otherwise oa-oauth would skip authorization
    [404, {}, ["go to /auth/linkedin\n"]]
  else
    [200,
     {'Content-Type' => 'text/html'},
     ['<pre>',
      CGI.escape_html(PP.pp(env['omniauth.auth'], '')),
      '</pre>']]
  end
}

=begin
{"provider"=>"linked_in",
 "uid"=>"...",
 "credentials"=>
  {"token"=>"...",
   "secret"=>"..."},
 "extra"=>
  {"access_token"=>
    #<OAuth::AccessToken:0x...
     @consumer=
      #<OAuth::Consumer:0x...
       @http=#<Net::HTTP api.linkedin.com:443 open=false>,
       @http_method=:post,
       @key="...",
       @options=
        {:signature_method=>"HMAC-SHA1",
         :request_token_path=>"/uas/oauth/requestToken",
         :authorize_path=>"/uas/oauth/authenticate",
         :access_token_path=>"/uas/oauth/accessToken",
         :proxy=>nil,
         :scheme=>:header,
         :http_method=>:post,
         :oauth_version=>"1.0",
         :site=>"https://api.linkedin.com"},
       @secret=
        "...",
       @uri=#<URI::HTTPS:0x... URL:https://api.linkedin.com>>,
     @params=
      {:oauth_token=>"...",
       "oauth_token"=>"...",
       :oauth_token_secret=>"...",
       "oauth_token_secret"=>"...",
       :oauth_expires_in=>"0",
       "oauth_expires_in"=>"0",
       :oauth_authorization_expires_in=>"0",
       "oauth_authorization_expires_in"=>"0"},
     @response=#<Net::HTTPOK 200 OK readbody=true>,
     @secret="...",
     @token="...">},
 "user_info"=>
  {"first_name"=>"Lin",
   "last_name"=>"Jen-Shin",
   "nickname"=>"679",
   "location"=>"Taiwan",
   "image"=>nil,
   "description"=>"source code cleaner at Cardinal Blue Software",
   "public_profile_url"=>"http://www.linkedin.com/pub/lin-jen-shin/32/a79/679",
   "urls"=>{"LinkedIn"=>"http://www.linkedin.com/pub/lin-jen-shin/32/a79/679"},
   "name"=>"Lin Jen-Shin"}}
=end
