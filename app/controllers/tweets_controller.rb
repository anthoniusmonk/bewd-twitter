class TweetsController < ApplicationController
  def index
    @tweets = tweets.all
    render 'tweets/index'
  end

  def create
    @tweets = Task.new(tweets_params)
    render 'tweets/create' if @tweet.save
  end

  private

  def tweet_params
    params.require(:tweet).permit(:content)
  end
end
