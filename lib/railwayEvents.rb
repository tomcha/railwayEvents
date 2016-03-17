# coding:utf-8

require 'sinatra/base'
require 'railwayEvents/version'
require 'railwayEvents/rssMaker'
module RailwayEvents
  class Application < Sinatra::Base
    get '/' do
      rss = RssMaker::Feeds.new(URI.encode("https://www.tetsudo.com/event/category/車両基地/"))
      content_type "application/xml"
      rss.makeFeeds
    end
  end
end
