# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# メインのサンプルユーザーを2人作成する
User.create!(name: "正太郎",
            email: "shotaro@kyodokoza.com",
            password:               "example01",
            password_confirmation:  "example01",
            activated: true,
            activated_at: Time.zone.now)

User.create!(name: "綾美",
              email: "ayami@kyodokoza.com",
              password:               "example01",
              password_confirmation:  "example01",
              activated: true,
              activated_at: Time.zone.now)

User.create!(name: "独身太郎",
                email: "dokushin@kyodokoza.com",
                password:               "example01",
                password_confirmation:  "example01",
                activated: true,
                activated_at: Time.zone.now)


User.create!(name: "有効化 無太",
                  email: "nashita@kyodokoza.com",
                  password:               "example01",
                  password_confirmation:  "example01",
                  activated: false)

# 追加のユーザーをまとめて生成する
6.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@kyodokoza.com"
  password = "password"
  User.create!(name: name,
              email: email,
              password:               password,
              password_confirmation:  password,
              activated: true,
              activated_at: Time.zone.now)
end

Relationship.create!(name: "松田家", 
                    from_user_id: 1, 
                    to_user_id: 2)

Relationship.create!(name: "松田家", 
                      from_user_id: 2, 
                      to_user_id: 1)