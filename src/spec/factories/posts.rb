# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    content { 'エコスで2日分の買い物' }
    price { 2400 }
    payment_at { Time.zone.local(2021, 9, 21, 12, 0o0, 0o0) }
  end

  factory :post2, class: 'Post' do
    content { '家賃' }
    price { 75_000 }
    payment_at { Time.zone.local(2021, 9, 5, 12, 0o0, 0o0) }
  end
end
