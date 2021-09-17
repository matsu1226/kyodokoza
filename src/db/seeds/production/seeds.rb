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