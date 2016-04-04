# encoding: utf-8

require 'sinatra/base'
require 'railway-events/version'
require 'railway-events/rss-maker'
require 'railway-events/kanji-wareki'

module RailwayEvents
  class Application < Sinatra::Base
    get '/yard.xml' do
      rss = RssMaker::Feeds.new(URI.encode("https://www.tetsudo.com/event/category/車両基地/"))
      content_type "application/xml"
      rss.makeFeeds
    end

    get '/sptrain.xml' do
      rss = RssMaker::Feeds.new(URI.encode("https://www.tetsudo.com/event/category/臨時列車/"))
      content_type "application/xml"
      rss.makeFeeds
    end

    get '/ride.xml' do
      rss = RssMaker::Feeds.new(URI.encode("https://www.tetsudo.com/event/category/乗り鉄/"))
      content_type "application/xml"
      rss.makeFeeds
    end
  end
end
