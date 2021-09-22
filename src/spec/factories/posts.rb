FactoryBot.define do
  factory :post do
    content { "エコスで2日分の買い物" }
    price { 2400 }
    payment_at { Time.local(2021, 9, 21, 12, 00, 00) }
  end
  
  factory :post2, class: "Post" do
    content { "家賃" }
    price { 75000 }
    payment_at { Time.local(2021, 9, 5, 12, 00, 00) }
  end
end
