Rails.application.routes.draw do
  root 'homepage#index'
  get '/feeds' => 'feeds#index'

  # USERS
  post '/users' => 'users#create'

  # SESSIONS
  post '/sessions' => 'sessions#create'
  get '/authenticated' => 'sessions#authenticated'
  delete '/sessions' => 'sessions#destroy'

  # TWEETS
  post '/tweets' => 'tweets#create'
  delete '/tweets' => 'tweets/:id#destroy'
  get '/tweets' => 'tweets#index'
  get '/users/:username/tweets' => 'tweet.username#index'

  # Redirect all other paths to index page, which will be taken over by AngularJS
  get '*path' => 'homepage#index'
end
