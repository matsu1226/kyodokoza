FactoryBot.define do
  factory :post do
    content { "エコスで2日分の買い物" }
    price { 2400 }
    purchased_at { Time.local(2021, 9, 21, 12, 00, 00) }
  end
end
