class StaticPagesController < ApplicationController
  def introduction
    @share_url = 'http%3A%2F%2Fwww.kyodokoza.com%2F'
    # @share_text = "夫婦やカップルで家計管理 | 共同口座専用の家計簿アプリ「キョウドウコウザ」"
    @share_text = '%E5%A4%AB%E5%A9%A6%E3%82%84%E3%82%AB%E3%83%83%E3%83%97%E3%83%AB%E3%81%A7%E5%AE%B6%E8%A8%88%E7%AE%A1%E7%90%86+%7C+%E5%85%B1%E5%90%8C%E5%8F%A3%E5%BA%A7%E5%B0%82%E7%94%A8%E3%81%AE%E5%AE%B6%E8%A8%88%E7%B0%BF%E3%82%A2%E3%83%97%E3%83%AA%E3%80%8C%E3%82%AD%E3%83%A7%E3%82%A6%E3%83%89%E3%82%A6%E3%82%B3%E3%82%A6%E3%82%B6%E3%80%8D'
    @hash_tag = '家計簿アプリ,家計簿,夫婦,カップル'
  end

end
