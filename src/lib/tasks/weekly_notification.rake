namespace :weekly_notification do
  desc '支出レポート'
  task weekly_notification: :environment do
    relationships = Relationship.all

    relationships.each do |relationship|
      UserMailer.weekly_notification(relationship).deliver
    end
  end
  # heroku_schedulerを使ったメール配信 https://qiita.com/1024xx4/items/c269172dda4a8aff8522
  # Rake tasksについて https://qiita.com/suzuki-koya/items/787b5562d2ae1a215d94
end
