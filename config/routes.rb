Rails.application.routes.draw do
  # ...
  get '/oauth2callback', to: 'oauth2#callback'
end
