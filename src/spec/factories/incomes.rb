FactoryBot.define do
  factory :income do
    user_id { 1 }
    price { 1 }
    content { "MyText" }
    deposit_at { "2021-09-22 08:43:27" }
  end
end
