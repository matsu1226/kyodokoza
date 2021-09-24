# docker + whenever https://qiita.com/ywzx/items/8f66107f665d5ec55e84
# wheneverにrailsを起動する必要があるためRails.rootを使用
rails_env = ENV['RAILS_ENV'] ||= 'production'


# ログを書き出すようファイル
set :output, error: 'log/crontab_error.log', standard: 'log/crontab.log'
set :environment, rails_env

# 環境変数をうまい感じにやってくれる
ENV.each { |k, v| env(k, v) }

every :monday, at: '9am' do
  rake 'weekly_notification:weekly_notification'
  # 実行時間の指定 https://www.school.ctc-g.co.jp/columns/masuidrive/masuidrive22.html
end

# every 2.minutes do
#   rake 'weekly_notification:test'
# end