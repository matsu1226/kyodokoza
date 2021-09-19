require 'rails_helper'

RSpec.describe "StaticPages", type: :system do

  let(:guest) { User.find_by(email: 'guest@example.com') }
  
  before do
    visit guest_sign_in_path
  end
  

  subject { page }
  
  it "家族の情報の表示" do
    visit user_path(user)
    should have_content "家族の情報"
    should_not have_content "家族の登録"
    visit relationship_path(user.relationship)
    should have_content "ゲスト一家"
    should have_content "ゲスト1"
    should have_content "ゲスト2"
  end

  describe "footerの表示" do
    before { visit user_path(user) }
    it { is_expected.to have_link nil, href: posts_path }  
    it { is_expected.to have_link nil, href: stats_month_path }  
    it { is_expected.to have_link nil, href: stats_year_path }  
    it { is_expected.to have_link nil, href: new_post_path } 
    it { is_expected.to have_link nil, href: categories_path } 
  end

  describe "カテゴリの表示" do
    before { visit categories_path }
    it { is_expected.to have_content "固定費" }
    it { is_expected.not_to have_content "食費" }
    it { is_expected.not_to have_content "通信費" }
    it { is_expected.not_to have_content "飲み会・旅行" }
    it { is_expected.not_to have_content "雑費" }
    it { is_expected.not_to have_content "その他" }
  end

  describe "月合計の表示" do
    before { visit stats_month_path }

    it "実績-目標テーブル / 合計列" do
      within '.total-table' do
        within '.total-sum' do
          is_expected.to have_content "¥ 118,000" # 合計
          is_expected.to have_content "¥ 246,000" # 合計
          is_expected.to have_content "¥ 128,000" # 合計
        end
      end
    end

    it "実績-目標テーブル / カテゴリ列" do
      within '.total-table' do
        is_expected.to have_content "¥ 100,000" # 固定費
        is_expected.to have_content "¥ 150,000" # 固定費
        is_expected.to have_content "¥ 5,0000" # 固定費
        is_expected.to have_content  "¥ 6,000" # 食費
        is_expected.to have_content "¥ 36,000" # 食費
        is_expected.to have_content "¥ 30,000" # 食費
        is_expected.to have_content  "¥ 8,000" # 通信費
        is_expected.to have_content "¥ 10,000" # 通信費
        is_expected.to have_content "¥ 2,000" # 通信費
      end
    end

    it "ユーザー毎テーブル / 合計" do
      within '.individual-table' do
        within '.total-sum' do
          is_expected.to have_content "¥ 10,000" # guest1
          is_expected.to have_content "¥ 8,000" # guest2
          is_expected.to have_content "¥ 100,000" # 共通
        end
      end
    end
    
  end

  describe "ログアウト" do
    before  do
      user_path(guest)
      click_link "ログアウト", href: logout_path
    end

    it { expect( Category.where(relationship_id: guest.relationship.id).count ).to eq 0  }
    it { expect( Post.where(user_id: guest.relationship.user_ids).count ).to eq 0  }
    it { expect(page).to have_content "ログアウトしました。" }
  end

end
