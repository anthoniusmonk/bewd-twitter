class TweetsController < ApplicationController
    belongs_to :user

    def index
        @tweets = tweets.all
        render 'tweets/index'
      end
      def create
        @tweets = Task.new(tweets_params)
        if @tweet.save
          render 'tweets/create' 
        end
      end

      private

        def tweet_params
          params.require(:tweet).permit(:content)
        end
    end
