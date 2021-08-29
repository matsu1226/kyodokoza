FactoryBot.define do
  factory :user do
    name { "正太郎" }
    email { "qqq.ms1126@gmail.com" }
    password { "example01" }
    password_confirmation { "example01" }
    activated { true }
    activated_at { Time.zone.now }
  end

  factory :user2, class: User do
    name { "綾美" }
    email { "ayami@gmail.com" }
    password { "example01" }
    password_confirmation { "example01" }
    activated { true }
    activated_at { Time.zone.now }
  end

  factory :other_user, class: User do
    name { "太郎" }
    email { "taro@gmail.com" }
    password { "example01" }
    password_confirmation { "example01" }
    activated { true }
    activated_at { Time.zone.now }
  end

end
