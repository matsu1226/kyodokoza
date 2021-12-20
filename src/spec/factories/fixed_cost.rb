# frozen_string_literal: true

FactoryBot.define do
  factory :fixed_cost_template, class: 'FixedCost' do
    content { '家賃' }
    price { 75_000 }
    payment_date { 27 }
  end

  factory :fixed_cost_template2, class: 'FixedCost' do
    content { '健康保険' }
    price { 60_000 }
    payment_date { 1 }
  end
end
