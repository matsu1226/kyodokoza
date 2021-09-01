# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# user
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


# relationship
Relationship.create!(name: "松田家", 
                    from_user_id: 1, 
                    to_user_id: 2)

Relationship.create!(name: "松田家", 
                      from_user_id: 2, 
                      to_user_id: 1)


# category
Category.create(name:"固定費",
                color:"#f00",
                content: "家賃、光熱費など")
Category.create(name:"食費",
                color:"#0f0",
                content: "スーバー、買い食い、外食など")
Category.create(name:"通信費",
                color:"#00f",
                content: "携帯代、wifi")
Category.create(name:"飲み会・旅行",
                color:"#ff0",
                content: "家賃、光熱費など")
Category.create(name:"雑費",
                color:"#0ff",
                content: "家賃、光熱費など")
Category.create(name:"交通費",
                color:"#f0f",
                content: "家賃、光熱費など")
Category.create(name:"その他",
                color:"#808080",
                content: "家賃、光熱費など")