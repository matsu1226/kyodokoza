require 'rails_helper'

RSpec.describe "Stats", type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user2) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:food_expenses) { FactoryBot.create(:food_expenses) }
  let!(:food_expenses2) { FactoryBot.create(:food_expenses2) }
  let!(:fixed_cost) { FactoryBot.create(:fixed_cost, relationship_id: user.relationship.id) }
  let!(:post) { FactoryBot.create(:post, price:2000, 
                                        user_id: user.id, 
                                        category_id: food_expenses.id)}
  let!(:post2) { FactoryBot.create(:post, price:2400, 
                                        user_id: user.id, 
                                        category_id: food_expenses.id)}
  let!(:post3) { FactoryBot.create(:post, price:2800, 
                                        user_id: user2.id, 
                                        category_id: food_expenses.id)} 
  let!(:post4) { FactoryBot.create(:post2,user_id: common_user.id, 
                                        category_id: fixed_cost.id)}
  let(:today) { Time.new(2021, 9 ,1, 9, 00, 00) }


  context "other_user" do
    before do
      login(other_user)
      visit categories_path
    end
    it { expect(page).to have_content "家族の登録をしてください" }
  end


  context "user" do
    before do
      login(user)
      travel_to today
    end
  
    it "create post(固定費)" do
      expect{FactoryBot.create(:post2,user_id: user.id, category_id: fixed_cost.id)}.to change { Post.count }.by(1)
    end
  
    it "create category(固定費)" do
      expect{FactoryBot.create(:fixed_cost, relationship_id: user.relationship.id)}.to change { Category.count }.by(1)
    end
  
    subject { page }
  
    context "月合計(stats_month_path)" do
      before { visit stats_month_path }
  
      describe "カテゴリ名" do
        it { is_expected.to have_content "食費" } # 食費
        it { is_expected.to have_content "固定費" } # 固定費
      end

      describe"total-table" do
        describe "実績" do
          it { is_expected.to have_content  "¥ 7,200" } # 食費
          it { is_expected.to have_content "¥ 75,000" } # 固定費
          it { is_expected.to have_content "¥ 82,200" } # 合計
        end
        describe "目標" do
          it { is_expected.to have_content "¥ 36,000" } # 食費
          it { is_expected.to have_content "¥ 50,000" } # 固定費
          it { is_expected.to have_content "¥ 86,000" } # 合計
        end
        describe "差異" do
          it { is_expected.to have_content "¥ 28,800" } # 食費
          it { is_expected.to have_content "¥ -25,000" } # 固定費
          it { is_expected.to have_content "¥ 3,800" } # 合計
        end
      end


      describe "individual-table" do
        describe "固定費" do
          it { is_expected.to have_content "¥ 4,400" } # user1
          it { is_expected.to have_content "¥ 2,800" } # user2
          it { is_expected.to have_content "¥ 75,000" } # その他
        end
      end
    end
  end
  
end
