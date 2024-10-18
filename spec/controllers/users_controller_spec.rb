require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  render_views

  describe 'POST /users' do
    it 'renders new user object' do
      post :create, params: { user: { username: 'test', email: 'test@test.com', password: 'password' } }
    
      expect(response.body).to eq({
        user: {
          username: 'test',
          email: 'test@test.com'
        }
      }.to_json)
    end
  end
end
