# frozen_string_literal: true

namespace :weekly_notification do
  desc '支出レポート'
  task weekly_notification: :environment do
    relationships = Relationship.all

    relationships.each do |relationship|
      UserMailer.weekly_notification(relationship).deliver
    end
  end
end
