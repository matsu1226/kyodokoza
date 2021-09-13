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

# 松田家の投稿
# timesの使い方 => https://qiita.com/takehanKosuke/items/79a66751fe95010ea5ee
12.times do |n|
  Post.create(content: "家賃_#{n+1}月25日",
              price: 75000,
              purchased_at: Time.local(2021, n+1, 25, 12, 00, 00),
              category_id: 1,
              user_id: 1)
end
12.times do |n|
  Post.create(content: "エコス_#{n}月10日",
              price: 3500-n*50,
              purchased_at: Time.local(2021, n+1, 10, 12, 00, 00),
              category_id: 2,
              user_id: 1)
end
12.times do |n|
  Post.create(content: "携帯_#{n}月20日",
              price: 4500,
              purchased_at: Time.local(2021, n+1, 20, 12, 00, 00),
              category_id: 3,
              user_id: 1)
end
12.times do |n|
  Post.create(content: "鳥貴族_#{n}月1日",
              price: 2000+n*100,
              purchased_at: Time.local(2021, n+1, 1, 12, 00, 00),
              category_id: 4,
              user_id: 1)
end
12.times do |n|
  Post.create(content: "ダイソー_#{n}月1日",
              price: 330,
              purchased_at: Time.local(2021, n+1, 1, 12, 00, 00),
              category_id: 5,
              user_id: 1)
end
12.times do |n|
  Post.create(content: "正太郎_立川往復_#{n}月12日",
              price: 316,
              purchased_at: Time.local(2021, n+1, 12, 12, 00, 00),
              category_id: 6,
              user_id: 1)
end
12.times do |n|
  Post.create(content: "綾美_立川往復_#{n}月12日",
              price: 316,
              purchased_at: Time.local(2021, n+1, 12, 12, 00, 00),
              category_id: 6,
              user_id: 2)
end
12.times do |n|
  Post.create(content: "歯医者_#{n}月1日",
              price: 2000,
              purchased_at: Time.local(2021, n+1, 1, 12, 00, 00),
              category_id: 7,
              user_id: 2)
end

Post.create(content: "エコス(山田家)",
            price: 1550,
            category_id: 9,
            purchased_at: Time.local(2021, 9, 1, 12, 00, 00),
            user_id: 3)