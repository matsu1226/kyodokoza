class WeeklyMailJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    Usermailer.weekly_notification
  end
end
