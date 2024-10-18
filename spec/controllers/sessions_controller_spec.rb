require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  render_views

  describe 'POST /sessions' do
    it 'renders new session object' do
      FactoryBot.create(:user, username: 'asdasdasd', password: 'asdasdasd')

      post :create, params: {
        user: {
          username: 'asdasdasd',
          password: 'asdasdasd'
        }
      }

      expect(response.body).to eq({
        success: true
      }.to_json)
    end
  end

  describe 'GET /authenticated' do
    let(:user) { FactoryBot.create(:user, username: 'testtest', password: 'password') }

    before do
      session = user.sessions.create
      cookies.permanent[:twitter_session_token] = session.token
    end

    it 'renders authenticated user object' do
      get :authenticated

      expect(response.body).to eq({
        authenticated: true,
        username: user.username
      }.to_json)
    end
  end

  describe 'DELETE /sessions' do
    let(:user) { FactoryBot.create(:user) }

    before do
      session = user.sessions.create
      cookies.permanent[:twitter_session_token] = session.token
    end

    it 'renders success' do
      delete :destroy

      expect(user.sessions.reload.count).to eq(0)
    end
  end
end