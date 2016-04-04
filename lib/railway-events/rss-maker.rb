# coding:utf-8

require 'net/http'
require 'uri'
require 'rss'
require 'date'
require 'open-uri'

module RssMaker
  class FeedSeeds
    attr :rssuri
    attr_reader :feed_seeds
    #車両基地イベント "https://www.tetsudo.com/event/category/%E8%BB%8A%E4%B8%A1%E5%9F%BA%E5%9C%B0/"
    #臨時列車イベント "https://www.tetsudo.com/event/category/%E8%87%A8%E6%99%82%E5%88%97%E8%BB%8A/"
    def initialize(originURL)
      @feed_seeds = Array.new()
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
          event_URL = "https://www.tetsudo.com#{$2}"
          event_name = $1
          event_date = $3
          tmp = OpenURI.open_uri(event_URL)
          File.open(tmp.open) do |f|
            f.read =~ /<p class="content-text".+?>(.+?)<\/p>/
            @event_description = $1
          end
          puts @event_description

          @feed_seeds.push ({
            event_URL: event_URL,
            event_name: event_name,
            event_date: event_date,
            event_description: @event_description
          })
        end
      end
      @feed_seeds.sort_by!{|elem|elem[:event_date]}.reverse!
    end
  end

  class Feeds
    attr_reader :rssObject
    def initialize(originalURL)
      @feed_seeds = FeedSeeds.new(originalURL)
      unescape_originalURL = URI.decode_www_form_component(originalURL)
      if unescape_originalURL =~ /臨時列車/
        @title = "臨時列車情報"
      elsif unescape_originalURL =~ /車両基地/
        @title = "車両基地イベント"
      elsif unescape_originalURL =~ /乗り鉄/
        @title = "乗り鉄イベント"
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
        for seed in (@feed_seeds.feed_seeds)
          item = maker.items.new_item
          item.link = seed[:event_URL]
          a = seed[:event_name]
          item.title = seed[:event_name].force_encoding('UTF-8') + ":" +seed[:event_date].force_encoding('UTF-8')
          item.description = seed[:event_description] 
#          item.date = seed[:eventDate].force_encoding('UTF-8')
        end
      end
      a.to_s
    end
  end
end
