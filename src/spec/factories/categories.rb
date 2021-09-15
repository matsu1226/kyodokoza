FactoryBot.define do
  factory :food_expenses, class:"Category" do
    name { "食費" }
    content { "スーパー、買い食い、外食など" }
    color { "#f00" }
    target_price { 36000 }
    association :relationship, factory: :relationship
  end

  factory :food_expenses2, class:"Category" do
    name { "食費２" }
    content { "スーパー、買い食い、外食など" }
    color { "#f00" }
    target_price { 36000 }
    association :relationship, factory: :relationship2
  end

  # fixed_cost
end

# rspecのアソシエーションの記述方法
# https://qiita.com/Ryoga_aoym/items/741c57e266a9d811a2d4
