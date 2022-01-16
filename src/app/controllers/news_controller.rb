class NewsController < ApplicationController
  before_action :only_first_user
  require "open-uri"
  def index
    #「節約」をURLエンコード
    api_key = ENV['NEWS_API_KEY']
    uri_source = "https://newsapi.org/v2/top-headlines?country=jp&apiKey=" + api_key
    uri_parse = URI.parse(uri_source) 
      # q=%E7%AF%80%E7%B4%84&   
    json = Net::HTTP.get(uri_parse)   # HTTP通信でAPIの情報を取得(json形式)
    # https://docs.ruby-lang.org/ja/latest/class/Net=3a=3aHTTP.html#I_GET
    puts "====json==== \n"
    puts json
    moments = JSON.parse(json)        # json形式の文字列をRuby_objectに変換
    @articles = moments['articles']
    puts "====@articles==== \n"
    puts @articles
  end

  private
   def only_first_user
    return if current_user == User.find_by(email: "qqq.ms1126@gmail.com")    
    # return if current_user == User.first
    redirect_to user_path(current_user)
   end
end
