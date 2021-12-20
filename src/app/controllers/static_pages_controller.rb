class StaticPagesController < ApplicationController
  def introduction
    @share_url = 'http%3A%2F%2Fwww.kyodokoza.com%2F'
    # @share_text = "夫婦やカップルで家計管理 | 共同口座専用の家計簿アプリ「キョウドウコウザ」"
    @share_text = '%E5%A4%AB%E5%A9%A6%E3%82%84%E3%82%AB%E3%83%83%E3%83%97%E3%83%AB%E3%81%A7%E5%AE%B6%E8%A8%88%E7%AE%A1%E7%90%86+%7C+%E5%85%B1%E5%90%8C%E5%8F%A3%E5%BA%A7%E5%B0%82%E7%94%A8%E3%81%AE%E5%AE%B6%E8%A8%88%E7%B0%BF%E3%82%A2%E3%83%97%E3%83%AA%E3%80%8C%E3%82%AD%E3%83%A7%E3%82%A6%E3%83%89%E3%82%A6%E3%82%B3%E3%82%A6%E3%82%B6%E3%80%8D'
    @hash_tag = '家計簿アプリ,家計簿,夫婦,カップル'
  end

  def guest_sign_in
    guest1 = User.find_or_create_by!(email: 'guest@example.com') do |guest1|
      password = SecureRandom.urlsafe_base64(10)
      guest1.name = 'ゲスト1'
      guest1.password = password
      guest1.password_confirmation = password
    end
    # guest1.activate

    guest2 = User.find_or_create_by!(email: 'guest2@example.com') do |guest2|
      password = SecureRandom.urlsafe_base64(10)
      guest2.name = 'ゲスト2'
      guest2.password = password
      guest2.password_confirmation = password
    end
    # guest2.activate

    common_guest = User.find_or_create_by!(email: 'common_guest@example.com') do |common_guest|
      password = SecureRandom.urlsafe_base64(10)
      common_guest.name = '共通'
      common_guest.password = password
      common_guest.password_confirmation = password
    end

    @relationship = Relationship.find_or_create_by!(name: 'ゲスト用家族')

    UserRelationship.find_or_create_by!(user_id: guest1.id, relationship_id: @relationship.id)
    UserRelationship.find_or_create_by!(user_id: guest2.id, relationship_id: @relationship.id)
    UserRelationship.find_or_create_by!(user_id: common_guest.id, relationship_id: @relationship.id)

    guest_category1 = Category.find_or_create_by!(name: '固定費',
                                                  color: '#ff4500',
                                                  content: '家賃、光熱費など',
                                                  relationship_id: @relationship.id,
                                                  target_price: 150_000)
    guest_category2 = Category.find_or_create_by!(name: '食費',
                                                  color: '#ffd700',
                                                  content: 'スーバー、買い食い、外食など',
                                                  relationship_id: @relationship.id,
                                                  target_price: 36_000)
    guest_category3 = Category.find_or_create_by!(name: '通信費',
                                                  color: '#0000cd',
                                                  content: '携帯代、wifi',
                                                  relationship_id: @relationship.id,
                                                  target_price: 10_000)
    guest_category4 = Category.find_or_create_by!(name: '飲み会・旅行',
                                                  color: '#4169e1',
                                                  content: '',
                                                  relationship_id: @relationship.id,
                                                  target_price: 20_000)
    guest_category5 = Category.find_or_create_by!(name: '雑費',
                                                  color: '#800080',
                                                  content: 'ドラッグストア、洋服など',
                                                  relationship_id: @relationship.id,
                                                  target_price: 20_000)
    guest_category6 = Category.find_or_create_by!(name: 'その他',
                                                  color: '#e9967a',
                                                  content: '病院や特殊な出費',
                                                  relationship_id: @relationship.id,
                                                  target_price: 10_000)

    Post.find_or_create_by!(content: '家賃',
                            price: 100_000,
                            payment_at: Time.zone.now,
                            category_id: guest_category1.id,
                            user_id: common_guest.id)

    Post.find_or_create_by!(content: 'サトウココノカドー',
                            price: 6000,
                            payment_at: Time.zone.now,
                            category_id: guest_category2.id,
                            user_id: guest1.id)

    Post.find_or_create_by!(content: '携帯',
                            price: 4000,
                            payment_at: Time.zone.now,
                            category_id: guest_category3.id,
                            user_id: guest2.id)

    Post.find_or_create_by!(content: '携帯',
                            price: 4000,
                            payment_at: Time.zone.now,
                            category_id: guest_category3.id,
                            user_id: guest1.id)

    Post.find_or_create_by!(content: 'カツモトキヨシ',
                            price: 4000,
                            payment_at: Time.zone.now,
                            category_id: guest_category5.id,
                            user_id: guest2.id)

    log_in guest1

    redirect_to new_post_path
    flash[:success] = 'ゲストユーザーとしてログインしました'
  end
end
