class SampleJob < ApplicationJob
  queue_as :default

  def perform(email)
    user = User.find(email: email)
    Post.create!(content: sidekiq_test,
                 price: 10000,
                 payment_at: Time.zone.now,
                 category_id: user.relationship.categories.first.id,
                 user_id: user.id)
  end
end
