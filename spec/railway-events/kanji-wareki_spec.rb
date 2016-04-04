require 'spec_helper'

describe 'KanjiWarekiChangerクラスが読み込める事'do
  it 'ドット区切りの西暦テキストが渡された時' do
    expect(KanjiWareki::KanjiWarekiChanger.to_wareki('2016.3.26')).to eq '平成28年3月26日'
    expect(KanjiWareki::KanjiWarekiChanger.to_wareki('1989.1.7')).to eq '昭和64年1月7日'
    expect(KanjiWareki::KanjiWarekiChanger.to_wareki('1989.1.8')).to eq '平成1年1月8日'
  end

  it '漢字の和暦を渡した時' do
    expect(KanjiWareki::KanjiWarekiChanger.to_seireki('平成28年3月26日')).to eq '2016.3.26'
    expect(KanjiWareki::KanjiWarekiChanger.to_seireki('昭和47年10月1日')).to eq '1972.10.1'
  end
end
