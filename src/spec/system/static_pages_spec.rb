require 'rails_helper'

RSpec.describe "StaticPages", type: :system do

  before(:each) do
    load Rails.root.join("db/seeds/test/seeds.rb")
  end

  let(:user) { User.find_by(email: 'guest@example.com') }
  let(:today) { Time.new(2021, 9 ,1, 9, 00, 00) }
  
  before do
    visit guest_sign_in_path
    travel_to today
  end
  
  describe "家族の情報" do

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

    it "一覧の表示" do
      visit posts_path
      is_expected.to have_content "¥ 140,224"
      is_expected.to have_content "¥ 251,000"
      is_expected.to have_content "¥ 110,776"
    end

    describe "月合計の表示" do
      before { visit stats_month_path }

      it "実績-目標テーブル / 合計列" do
        within '.total-table' do
          within '.total-sum' do
            is_expected.to have_content "¥ 140,224"
            is_expected.to have_content "¥ 251,000"
            is_expected.to have_content "¥ 110,776"
          end
        end
      end

      it "実績-目標テーブル / カテゴリ列" do
        within '.total-table' do
          is_expected.to have_content "¥ 24,200" # 食費
          is_expected.to have_content "¥ 36,000" # 食費
          is_expected.to have_content "¥ 11,800" # 食費
          is_expected.to have_content "¥ 80,000" # 固定費
          is_expected.to have_content "¥ 150,000" # 固定費
          is_expected.to have_content "¥ 70,000" # 固定費
        end
      end

      it "individual-table" do
        within '.individual-table' do
          within '.total-sum' do
            is_expected.to have_content "¥ 51,222"
            is_expected.to have_content "¥ 6,502"
            is_expected.to have_content "¥ 82,500"
          end
        end
      end
    end
  end


end
