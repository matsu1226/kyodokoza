# frozen_string_literal: true

FactoryBot.define do
  factory :income do
    content { '給料' }
    price { 160_000 }
    payment_at { Time.zone.local(2021, 9, 25, 12, 0o0, 0o0) }
  end

  factory :income2, class: 'Income' do
    content { '給料' }
    price { 100_000 }
    payment_at { Time.zone.local(2021, 9, 26, 12, 0o0, 0o0) }
  end
end
