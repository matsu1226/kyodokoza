class WeeklyMailJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    UserMailer.weekly_notification.deliver_now
    puts "==== send WeeklyMail!! ===="
  end
end
