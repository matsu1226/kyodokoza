FactoryBot.define do
  factory :relationship do
    name { "松田家" }
    created_at { Time.local(2021, 8, 31, 12, 00, 00) }
    after(:create) do |relationship|
      user = User.find_by(email: "shotaro@kyodokoza.com")
      user2 = User.find_by(email: "ayami@kyodokoza.com")
      relationship.user_relationships << FactoryBot.build(:user_relationship, user: user )
      relationship.user_relationships << FactoryBot.build(:user_relationship, user: user2)
    end
  end

  factory :relationship2, class: "Relationship" do
    name { "山田家" }
    after(:create) do |relationship|
      user3 = FactoryBot.create(:user3)
      user4 = FactoryBot.create(:user4)
      relationship.user_relationships << FactoryBot.build(:user_relationship, user: user3)
      relationship.user_relationships << FactoryBot.build(:user_relationship, user: user4)
    end
  end
end

# 多対多のアソシエーション
# https://qiita.com/takehanKosuke/items/ae324483e7f9451bf6a7
