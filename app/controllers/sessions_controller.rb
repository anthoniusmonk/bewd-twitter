class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:destroy]
  def create
    user = User.find_by(username: params[:user][:username])

    if user&.authenticate(params[:user][:password])
      session = user.sessions.create
      cookies.permanent[:twitter_session_token] = session.token
      render json: { message: 'Session created successfully' }, status: :created
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  def authenticated
    session = Session.find_by(token: cookies[:twitter_session_token])

    if session
      render json: { authenticated: true }, status: :ok
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
