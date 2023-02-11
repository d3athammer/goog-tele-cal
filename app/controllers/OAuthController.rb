client = Signet::OAuth2::Client.new(
  authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
  token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
  client_id: ENV["GOOG_CLIENT_ID"],
  client_secret: ENV["GOOG_CLIENT_SECRET"],
  redirect_uri: <your_redirect_uri>,
  scope: 'https://www.googleapis.com/auth/calendar'
)
redirect_to client.authorization_uri.to_s
