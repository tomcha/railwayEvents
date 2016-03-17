# coding:utf-8

require 'net/http'
require 'uri'
require 'rss'

module RssMaker
  class FeedSeeds
    attr :rssuri
    attr_reader :feedSeeds
    #車両基地イベント "https://www.tetsudo.com/event/category/%E8%BB%8A%E4%B8%A1%E5%9F%BA%E5%9C%B0/"
    #臨時列車イベント "https://www.tetsudo.com/event/category/%E8%87%A8%E6%99%82%E5%88%97%E8%BB%8A/"
    def initialize(originURL)
      @feedSeeds = Array.new()
      url = URI.parse(originURL)
      req = Net::HTTP::Get.new(url.path)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      res = nil
      http.start do |h|
        res = h.request(req)
      end
      res.body.gsub!(/\s|\t|\n/, "")
      arr = res.body.scan(/"evnt-duration">(.+?)<\/li/)
      for elem in arr do 
        e = elem.pack("A*")
        if (e =~ /title="(.+?)"href="(.+?)">.+?<time>(.+?)<\/time>/)
          @feedSeeds.push ({
            eventURL: "https://www.tetsudo.com#{$2}",
            eventName: $1,
            eventDate: $3,
          })
        end
      end
    end
  end

  class Feeds
    attr_reader :rssObject
    def initialize(originalURL)
      @feedSeeds = FeedSeeds.new(originalURL)
      unescapeOriginalURL = URI.decode_www_form_component(originalURL)
      if unescapeOriginalURL =~ /臨時列車/
        @title = "臨時列車情報"
      elsif unescapeOriginalURL =~ /車両基地/
        @title = "車両基地イベント"
      else
        @title = "タイトル取得不能"
      end
    end

    def makeFeeds
      a = RSS::Maker.make("2.0") do |maker|
        maker.channel.about = "http://tomch.net/railwayEvents/index.rdf"
        maker.channel.title = @title
        maker.channel.description = @title
        maker.channel.link = "http://tomch.net/railwayEvents/"
        for seed in (@feedSeeds.feedSeeds)
          item = maker.items.new_item
          item.link = seed[:eventURL]
          a = seed[:eventName]
          item.title = seed[:eventName].force_encoding('UTF-8') + ":" +seed[:eventDate].force_encoding('UTF-8')
        end
      end
      a.to_s
    end
  end
end
