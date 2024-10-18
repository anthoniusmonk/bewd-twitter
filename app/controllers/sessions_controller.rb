class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]

  def create
    user = User.find_by(username: params[:user][:username])
  
    if user&.authenticate(params[:user][:password])
      user.sessions.destroy_all
      session = user.sessions.create
  
      if session.persisted?
        Rails.logger.debug "Session created: #{session.inspect}"
        cookies.permanent[:twitter_session_token] = session.token
        render json: { success: true }, status: :created
      else
        render json: { error: 'Session creation failed' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  def authenticated
    token = cookies[:twitter_session_token]
    Rails.logger.debug "Session token retrieved: #{token}"
    session = Session.find_by(token: token)
  
    if session
      render json: { authenticated: true, username: session.user.username }, status: :ok
    else
      render json: { authenticated: false }, status: :unauthorized
    end
  end

  def destroy
    session = Session.find_by(token: cookies[:twitter_session_token])

    if session
      session.destroy
      cookies.delete(:twitter_session_token)
      render json: { message: 'Logged out successfully' }, status: :ok
    else
      render json: { error: 'Session not found' }, status: :not_found
    end
  end
end