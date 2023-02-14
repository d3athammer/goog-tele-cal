# app/controllers/oauth2_controller.rb
class Oauth2Controller < ApplicationController
  def callback
    # exchange the authorization code for an access token and refresh token
    client = Signet::OAuth2::Client.new(
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://oauth2.googleapis.com/token',
      client_id: ENV['GOOG_CLIENT_ID'],
      client_secret: ENV['GOOG_CLIENT_SECRET'],
      redirect_uri: 'http://localhost:3000/oauth2callback',
      code: params[:code]
    )
    client.fetch_access_token!

    # store the access token and refresh token in the .env file
    File.open('.env', 'a') do |f|
      f.write("GOOG_ACCESS_TOKEN=#{client.access_token}\n")
      f.write("GOOG_REFRESH_TOKEN=#{client.refresh_token}\n")
    end

    redirect_to root_path
  end
end
