require "sinatra/base"
require "sinatra/content_for"
require "sinatra/contrib"
require "rubygems"
require "twitter"
require "aylien_text_api"

class AnalyzeTweets < Sinatra::Base
  register Sinatra::Contrib
  set :haml, format: :html5

  before do
    @twitter = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["TWITTER_FOOBAR_KEY"]
      config.consumer_secret = ENV["TWITTER_FOOBAR_SECRET"]
      config.bearer_token = ENV["TWITTER_BEARER_TOKEN"]
    end

    AylienTextApi.configure do |config|
      config.app_id = ENV["ALYEN_ID"]
      config.app_key = ENV["ALYEN_KEY"]
    end

    @alyien = AylienTextApi::Client.new
  end

  get "/" do
    haml :index
  end

  post "/search" do
    @@tweets = []
    @twitter.search("to:#{params[:search]}", result_type: "recent").take(params[:count].to_i).collect do |tweet|
      sentiment = @alyien.sentiment text: tweet.text, mode: "tweet"
      concepts = @alyien.concepts text: tweet.text, language: "en"
      @@tweets << { tweet: { user_name: tweet.user.screen_name, text: tweet.text },
                    sentiment: sentiment,
                    concepts: concepts }
    end

    haml :search
  end

  get "/search" do
    json @@tweets.to_json
  end
end
