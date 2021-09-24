FactoryBot.define do
  factory :income do
    content { "給料" }
    price { 160000 }
    payment_at { Time.local(2021, 9, 25, 12, 00, 00) }
  end

  factory :income2, class: "Income" do
    content { "給料" }
    price { 100000 }
    payment_at { Time.local(2021, 9, 26, 12, 00, 00) }
  end
end
