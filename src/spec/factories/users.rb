FactoryBot.define do
  factory :user do
    name { "正太郎" }
    email { "shotaro@kyodokoza.com" }
    password { "example01" }
    password_confirmation { "example01" }
    activated { true }
    activated_at { Time.zone.now }

    trait :skip_validate do
      to_create {|instance| instance.save(validate: false)}
    end
    # https://qiita.com/nishina555/items/385002db18d6882be639
    
    factory :user2 do
      name { "綾美" }
      email { "ayami@kyodokoza.com" }
    end
    
    factory :user3 do
      name { "健太" }
      email { "kenta@kyodokoza.com" }
    end
    
    factory :user4 do
      name { "由美" }
      email { "yumi@kyodokoza.com" }
    end
    
    factory :other_user do
      name { "太郎" }
      email { "taro@gmail.com" }
    end
    
  end
end
