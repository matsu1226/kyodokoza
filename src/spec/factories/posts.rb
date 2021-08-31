FactoryBot.define do
  factory :post do
    user_id { 1 }
    content { "MyText" }
    price { 1 }
  end
end
