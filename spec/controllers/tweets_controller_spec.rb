require 'rails_helper'

RSpec.describe TweetsController, type: :controller do
  render_views

  describe 'POST /tweets' do
    it 'renders a success message' do
      user = FactoryBot.create(:user)
      session = user.sessions.create
      @request.cookie_jar.signed['twitter_session_token'] = session.token

      post :create, params: { tweet: { message: 'Test Message' } }

      expect(response.body).to eq({ message: 'Tweet created successfully' }.to_json)
    end
  end

  describe 'GET /tweets' do
    it 'renders all tweets object' do
      user = FactoryBot.create(:user)
      tweet1 = FactoryBot.create(:tweet, user: user, message: 'Test Message')
      tweet2 = FactoryBot.create(:tweet, user: user, message: 'Test Message')
    
      get :index
    
      expect(JSON.parse(response.body)).to match_array([
        a_hash_including('id' => tweet1.id, 'message' => 'Test Message', 'user' => { 'username' => user.username }),
        a_hash_including('id' => tweet2.id, 'message' => 'Test Message', 'user' => { 'username' => user.username })
      ])
    end
  end

  describe 'DELETE /tweets/:id' do
    it 'renders success message on deletion' do
      user = FactoryBot.create(:user)
      session = user.sessions.create
      @request.cookie_jar.signed['twitter_session_token'] = session.token

      tweet = FactoryBot.create(:tweet, user: user)

      delete :destroy, params: { id: tweet.id }

      expect(response.body).to eq({ message: 'Tweet deleted successfully' }.to_json)
      expect(user.tweets.count).to eq(0)
    end

    it 'renders error if not logged in' do
      user = FactoryBot.create(:user)
      tweet = FactoryBot.create(:tweet, user: user)

      delete :destroy, params: { id: tweet.id }

      expect(response.body).to eq({ error: 'Unauthorized' }.to_json)
      expect(user.tweets.count).to eq(1)
    end
  end

  describe 'GET /users/:username/tweets' do
    it 'renders tweets by username' do
      user1 = FactoryBot.create(:user, username: 'user1', email: 'user1@user.com')
      tweet1 = FactoryBot.create(:tweet, user: user1, message: 'Test Message')

      get :index_by_user, params: { username: user1.username }

      expect(response.body).to eq([
        {
          id: tweet1.id,
          message: 'Test Message',
          user: { username: user1.username }
        }
      ].to_json)
    end
  end
end