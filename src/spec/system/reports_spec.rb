require 'rails_helper'

RSpec.describe "Reports", type: :system do
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
                                        user_id: user.id, 
                                        category_id: food_expenses.id)} 
  let!(:post4) { FactoryBot.create(:post2,user_id: user.id, 
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
  
    describe "まとめて出力" do
      it "fromとtoが逆転（エラー）" do
        visit report_multiple_path
        select '2021', from: "_from_date_1i"
        select '9月', from: "_from_date_2i"
        select '2021', from: "_to_date_1i"
        select '8月', from: "_to_date_2i"
        click_button "エクセル出力"
        expect(page).to have_content "正しい年月を入力してください"
      end
    end
  end

end
