# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# ==== guest機能 ====
password = SecureRandom.urlsafe_base64(10)
guest1 = User.create!(name: "ゲスト1",
  email: "guest@example.com",
  password:               password,
  password_confirmation:  password,
  activated: true,
  activated_at: Time.zone.now)

password = SecureRandom.urlsafe_base64(10)
guest2 = User.create!(name: "ゲスト2",
  email: "guest2@example.com",
  password:               password,
  password_confirmation:  password,
  activated: true,
  activated_at: Time.zone.now)

password = SecureRandom.urlsafe_base64(10)
common_guest = User.create!(name: "共通",
  email: "common_#{guest1.id}@example.com",
  password:               password,
  password_confirmation:  password,
  activated: true,
  activated_at: Time.zone.now)

guest_relationship = Relationship.create(name: "ゲスト一家")

guest1.create_user_relationship(relationship_id: guest_relationship.id)
guest2.create_user_relationship(relationship_id: guest_relationship.id)
common_guest.create_user_relationship(relationship_id: guest_relationship.id)

guest_category1 = Category.create(name:"固定費",
  color:"#ff4500",
  content: "家賃、光熱費など",
  relationship_id: guest_relationship.id,
  target_price: 150000)
guest_category2 = Category.create(name:"食費",
  color:"#ffd700",
  content: "スーバー、買い食い、外食など",
  relationship_id: guest_relationship.id,
  target_price: 36000)
guest_category3 = Category.create(name:"通信費",
  color:"#0000cd",
  content: "携帯代、wifi",
  relationship_id: guest_relationship.id,
  target_price: 10000)
guest_category4 = Category.create(name:"飲み会・旅行",
  color:"#4169e1",
  content: "",
  relationship_id: guest_relationship.id,
  target_price: 20000)
guest_category5 = Category.create(name:"雑費",
  color:"#800080",
  content: "ドラッグストア、洋服など",
  relationship_id: guest_relationship.id,
  target_price: 20000)
guest_category6 = Category.create(name:"交通費",
  color:"#696969",
  content: "",
  relationship_id: guest_relationship.id,
  target_price: 5000)
guest_category7 = Category.create(name:"その他",
  color:"#e9967a",
  content: "病院や特殊な出費",
  relationship_id: guest_relationship.id,
  target_price: 10000)


12.times do |n|
  Post.create(content: "家賃_#{n+1}月25日",
    price: 80000,
    purchased_at: Time.local(2021, n+1, 25, 12, 00, 00),
    category_id: guest_category1.id,
    user_id: common_guest.id)
  Post.create(content: "サトーココノカドー_#{n+1}月10日",
    price: 6600+n*50,
    purchased_at: Time.local(2021, n+1, 10, 12, 00, 00),
    category_id: guest_category2.id,
    user_id: guest1.id)
  Post.create(content: "サトーココノカドー_#{n+1}月22日",
    price: 6900-n*100,
    purchased_at: Time.local(2021, n+1, 22, 12, 00, 00),
    category_id: guest_category2.id,
    user_id: guest1.id)
  Post.create(content: "ZEON_#{n+1}月3日",
    price: 7200-n*100,
    purchased_at: Time.local(2021, n+1, 3, 12, 00, 00),
    category_id: guest_category2.id,
    user_id: guest1.id)
  Post.create(content: "ZEON_#{n+1}月24日",
    price: 5500-n*100,
    purchased_at: Time.local(2021, n+1, 24, 12, 00, 00),
    category_id: guest_category2.id,
    user_id: guest1.id)
  Post.create(content: "携帯_#{n+1}月20日",
    price: 2500,
    purchased_at: Time.local(2021, n+1, 20, 12, 00, 00),
    category_id: guest_category3.id,
    user_id: guest1.id)
  Post.create(content: "携帯_#{n+1}月20日",
    price: 2500,
    purchased_at: Time.local(2021, n+1, 20, 12, 00, 00),
    category_id: guest_category3.id,
    user_id: guest2.id)
  Post.create(content: "ホームルーター_#{n+1}月20日",
    price: 2500,
    purchased_at: Time.local(2021, n+1, 20, 12, 00, 00),
    category_id: guest_category3.id,
    user_id: common_guest.id)
  Post.create(content: "犬貴族_#{n+1}月1日",
    price: 3000+n*200,
    purchased_at: Time.local(2021, n+1, 1, 12, 00, 00),
    category_id: guest_category4.id,
    user_id: guest1.id)
  Post.create(content: "カイソー_#{n+1}月1日",
    price: 550,
    purchased_at: Time.local(2021, n+1, 1, 12, 00, 00),
    category_id: guest_category5.id,
    user_id: guest2.id)
  Post.create(content: "カイソー_#{n+1}月21日",
    price: 770,
    purchased_at: Time.local(2021, n+1, 21, 12, 00, 00),
    category_id: guest_category5.id,
    user_id: guest1.id)
  Post.create(content: "ヤマキヨ_#{n+1}月2日",
    price: 2700,
    purchased_at: Time.local(2021, n+1, 2, 12, 00, 00),
    category_id: guest_category5.id,
    user_id: guest1.id)
  Post.create(content: "東京_立川往復_#{n+1}月12日",
    price: 1452,
    purchased_at: Time.local(2021, n+1, 12, 12, 00, 00),
    category_id: guest_category6.id,
    user_id: guest1.id)
  Post.create(content: "東京_立川往復_#{n+1}月12日",
    price: 1452,
    purchased_at: Time.local(2021, n+1, 12, 12, 00, 00),
    category_id: guest_category6.id,
    user_id: guest2.id)
  Post.create(content: "歯医者_#{n+1}月1日",
    price: 2000,
    purchased_at: Time.local(2021, n+1, 1, 12, 00, 00),
    category_id: guest_category7.id,
    user_id: guest2.id)
end

6.times do |n|
  Post.create(content: "王国ホテル_#{2*n+1}月12日",
  price: 15000,
  purchased_at: Time.local(2021, 2*n+1, 12, 12, 00, 00),
  category_id: guest_category4.id,
  user_id: guest1.id)
end

# ==== guest機能 ここまで ====


# user
# 松田家
user1 = User.create!(name: "正太郎",
  email: "shotaro@kyodokoza.com",
  password:               "example01",
  password_confirmation:  "example01",
  activated: true,
  activated_at: Time.zone.now)

user2 = User.create!(name: "綾美",
  email: "ayami@kyodokoza.com",
  password:               "example01",
  password_confirmation:  "example01",
  activated: true,
  activated_at: Time.zone.now)

common_user_password = SecureRandom.urlsafe_base64(10)
common_user = User.create!(name: "共通", 
        email: "common_#{user1.id}@kyodokoza.com", 
        password: common_user_password, 
        password_confirmation: common_user_password)

# 山田家
user3 = User.create!(name: "健太",
  email: "kenta@kyodokoza.com",
  password:               "example01",
  password_confirmation:  "example01",
  activated: true,
  activated_at: Time.zone.now)

user4 = User.create!(name: "由美",
  email: "yumi@kyodokoza.com",
  password:               "example01",
  password_confirmation:  "example01",
  activated: true,
  activated_at: Time.zone.now)

common_user2_password = SecureRandom.urlsafe_base64(10)
common_user2 = User.create!(name: "共通_2", 
        email: "common_#{user3.id}@kyodokoza.com", 
        password: common_user2_password, 
        password_confirmation: common_user2_password)

#その他 
user5 = User.create!(name: "独身太郎",
  email: "dokushin@kyodokoza.com",
  password:               "example01",
  password_confirmation:  "example01",
  activated: true,
  activated_at: Time.zone.now)


user6 = User.create!(name: "有効化 無太",
  email: "nashita@kyodokoza.com",
  password:               "example01",
  password_confirmation:  "example01",
  activated: false)


# relationship
relationship1 = Relationship.create!(name: "松田家")
relationship2 =  Relationship.create!(name: "山田家")

# user_relationship
UserRelationship.create!(user_id: user1.id, relationship_id: relationship1.id)
UserRelationship.create!(user_id: user2.id, relationship_id: relationship1.id)
UserRelationship.create!(user_id: common_user.id, relationship_id: relationship1.id)
UserRelationship.create!(user_id: user3.id, relationship_id: relationship2.id)
UserRelationship.create!(user_id: user4.id, relationship_id: relationship2.id)
UserRelationship.create!(user_id: common_user2.id, relationship_id: relationship2.id)


# 松田家のカテゴリ
category1 = Category.create(name:"固定費",
color:"#ff0000",
content: "家賃、光熱費など",
relationship_id: relationship1.id,
target_price: 150000)
category2 = Category.create(name:"食費",
color:"#00ff00",
content: "スーバー、買い食い、外食など",
relationship_id: relationship1.id,
target_price: 36000)
category3 = Category.create(name:"通信費",
color:"#0000ff",
content: "携帯代、wifi",
relationship_id: relationship1.id,
target_price: 10000)
category4 = Category.create(name:"飲み会・旅行",
color:"#ffff00",
content: "",
relationship_id: relationship1.id,
target_price: 20000)
category5 = Category.create(name:"雑費",
color:"#00ffff",
content: "ドラッグストア、洋服など",
relationship_id: relationship1.id,
target_price: 20000)
category6 = Category.create(name:"交通費",
color:"#ff00ff",
content: "",
relationship_id: relationship1.id,
target_price: 5000)
category7 = Category.create(name:"その他",
color:"#808080",
content: "病院や特殊な出費",
relationship_id: relationship1.id,
target_price: 10000)


# 山田家のカテゴリ
category8 = Category.create(name:"固定費２",
color:"#ff0000",
content: "家賃、光熱費など",
relationship_id: relationship2.id,
target_price: 150000)
category9 = Category.create(name:"食費２",
color:"#00ff00",
content: "スーバー、買い食い、外食など",
relationship_id: relationship2.id,
target_price: 40000)
category10 = Category.create(name:"通信費２",
color:"#0000ff",
content: "携帯代、wifi",
relationship_id: relationship2.id,
target_price: 10000)

# 松田家の投稿
# timesの使い方 => https://qiita.com/takehanKosuke/items/79a66751fe95010ea5ee
12.times do |n|
Post.create(content: "家賃_#{n+1}月25日",
price: 75000,
purchased_at: Time.local(2021, n+1, 25, 12, 00, 00),
category_id: category1.id,
user_id: user1.id)
end
12.times do |n|
Post.create(content: "エコス_#{n+1}月10日",
price: 4200-n*50,
purchased_at: Time.local(2021, n+1, 10, 12, 00, 00),
category_id: category2.id,
user_id: user1.id)
end
12.times do |n|
Post.create(content: "業務スーパー_#{n+1}月3日",
price: 3300-n*50,
purchased_at: Time.local(2021, n+1, 3, 12, 00, 00),
category_id: category2.id,
user_id: user1.id)
end
12.times do |n|
Post.create(content: "携帯_#{n+1}月20日",
price: 4500,
purchased_at: Time.local(2021, n+1, 20, 12, 00, 00),
category_id: category3.id,
user_id: user1.id)
end
12.times do |n|
Post.create(content: "鳥貴族_#{n+1}月1日",
price: 2000+n*100,
purchased_at: Time.local(2021, n+1, 1, 12, 00, 00),
category_id: category4.id,
user_id: user1.id)
end
6.times do |n|
Post.create(content: "一心_#{2*n+1}月12日",
price: 6000,
purchased_at: Time.local(2021, 2*n+1, 12, 12, 00, 00),
category_id: category4.id,
user_id: user1.id)
end
12.times do |n|
Post.create(content: "ダイソー_#{n+1}月1日",
price: 330,
purchased_at: Time.local(2021, n+1, 1, 12, 00, 00),
category_id: category5.id,
user_id: user1.id)
end
12.times do |n|
Post.create(content: "マツキヨ_#{n+1}月2日",
price: 2700,
purchased_at: Time.local(2021, n+1, 2, 12, 00, 00),
category_id: category5.id,
user_id: user1.id)
end
12.times do |n|
Post.create(content: "正太郎_立川往復_#{n+1}月12日",
price: 316,
purchased_at: Time.local(2021, n+1, 12, 12, 00, 00),
category_id: category6.id,
user_id: user1.id)
end
12.times do |n|
Post.create(content: "綾美_立川往復_#{n+1}月12日",
price: 316,
purchased_at: Time.local(2021, n+1, 12, 12, 00, 00),
category_id: category6.id,
user_id: user2.id)
end
12.times do |n|
Post.create(content: "歯医者_#{n+1}月1日",
price: 2000,
purchased_at: Time.local(2021, n+1, 1, 12, 00, 00),
category_id: category7.id,
user_id: user2.id)
end

Post.create(content: "エコス(山田家)",
price: 1550,
category_id: category9.id,
purchased_at: Time.local(2021, 9, 1, 12, 00, 00),
user_id: user3.id)