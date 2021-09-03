FactoryBot.define do
  factory :food_expenses, class:"Category" do
    name { "食費" }
    content { "スーパー、買い食い、外食など" }
    color { "#f00" }
    relationship_id { 1 }
  end

  # fixed_cost
end
