class WeeklyMailJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    User.where(send_weekly_mail: true).each do |user|
      return if user.no_relationship?
      UserMailer.weekly_notification(user).deliver_later
      puts "==== send WeeklyMail!! ===="
      puts "==== user_name => #{user.name} ===="
    end
  end
end
