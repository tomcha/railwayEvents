# coding:utf-8
require 'date'

module KanjiWareki
  class KanjiWarekiChanger
    def self.to_wareki(seireki_date)
      date = Date.parse(seireki_date).jisx0301
            date =~ /^(H|S|T|M)0?(\d+)\.0?(\d+)\.0?(\d+)$/
            if $1 == 'H'
              go = '平成'
            elsif $1 == 'S'
              go = '昭和'
            elsif $1 == 'T'
              go = '大正'
            elsif $1 == 'M'
              go = '明治'
            else
              go = $1
            end
            "#{go}#{$2}年#{$3}月#{$4}日"
    end

    def self.to_seireki(wareki_date)
      wareki_date =~ /^(平成|昭和|大正|明治)(\d+)年(\d+)月(\d+)日$/
      if $1 == '平成'
        y = $2.to_i + 1988
      elsif $1 == '昭和'
        y = $2.to_i + 1925
      elsif $1 == '大正'
        y = $2.to_i + 1911
      elsif $1 == '明治'
        y = $2.to_i + 1867
      end
      "#{y}.#{$3}.#{$4}"
    end
  end
end
