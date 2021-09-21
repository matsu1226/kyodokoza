namespace :weekly_notification do
  desc '支出レポート'
  task weekly_notification: :environment do
    relationships = Relationship.all

    relationships.each do |relationship|
      UserMailer.weekly_notification(relationship).deliver
    end
  end
  # Rake tasksについて https://qiita.com/suzuki-koya/items/787b5562d2ae1a215d94
  # task test: :environment do
  #   puts Time.now
  #   puts "test!"
  # end
end
