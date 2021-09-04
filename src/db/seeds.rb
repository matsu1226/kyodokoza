# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# user
# 松田家
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

# 山田家
User.create!(name: "健太",
                email: "kenta@kyodokoza.com",
                password:               "example01",
                password_confirmation:  "example01",
                activated: true,
                activated_at: Time.zone.now)
    
User.create!(name: "由美",
                  email: "yumi@kyodokoza.com",
                  password:               "example01",
                  password_confirmation:  "example01",
                  activated: true,
                  activated_at: Time.zone.now)

#その他 
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
2.times do |n|
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
Relationship.create!(name: "松田家")
Relationship.create!(name: "山田家")

# user_relationship
UserRelationship.create!(user_id: 1, relationship_id: 1)
UserRelationship.create!(user_id: 2, relationship_id: 1)
UserRelationship.create!(user_id: 3, relationship_id: 2)
UserRelationship.create!(user_id: 4, relationship_id: 2)



# 松田家のカテゴリ
Category.create(name:"固定費",
                color:"#ff0000",
                content: "家賃、光熱費など",
                relationship_id: 1)
Category.create(name:"食費",
                color:"#00ff00",
                content: "スーバー、買い食い、外食など",
                relationship_id: 1)
Category.create(name:"通信費",
                color:"#0000ff",
                content: "携帯代、wifi",
                relationship_id: 1)
Category.create(name:"飲み会・旅行",
                color:"#ffff00",
                content: "家賃、光熱費など",
                relationship_id: 1)
Category.create(name:"雑費",
                color:"#00ffff",
                content: "家賃、光熱費など",
                relationship_id: 1)
Category.create(name:"交通費",
                color:"#ff00ff",
                content: "家賃、光熱費など",
                relationship_id: 1)
Category.create(name:"その他",
                color:"#808080",
                content: "家賃、光熱費など",
                relationship_id: 1)


# 山田家のカテゴリ
Category.create(name:"固定費２",
                  color:"#ff0000",
                  content: "家賃、光熱費など",
                  relationship_id: 2)
Category.create(name:"食費２",
                  color:"#00ff00",
                  content: "スーバー、買い食い、外食など",
                  relationship_id: 2)
Category.create(name:"通信費２",
                  color:"#0000ff",
                  content: "携帯代、wifi",
                  relationship_id: 2)