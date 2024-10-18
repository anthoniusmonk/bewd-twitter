class TweetsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :require_user, only: [:create, :destroy]

  def create
    tweet = @current_user.tweets.build(tweet_params)

    if tweet.save
      render json: { message: 'Tweet created successfully' }, status: :created
    else
      render json: { errors: tweet.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    tweet = @current_user.tweets.find_by(id: params[:id])
  
    if tweet
      tweet.destroy
      render json: { message: 'Tweet deleted successfully' }, status: :ok
    else
      render json: { error: 'Tweet not found or not authorized' }, status: :not_found
    end
  end

  def index
    tweets = Tweet.includes(:user).all
    render json: tweets.as_json(include: { user: { only: :username } }), status: :ok
  end

  def index_by_user
    user = User.find_by(username: params[:username])

    if user
      render json: user.tweets.as_json(only: [:id, :message], include: { user: { only: :username } }), status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:message)
  end

  def require_user
    @current_user = Session.find_by(token: cookies.signed[:twitter_session_token])&.user
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end
end