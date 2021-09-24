require 'rails_helper'

RSpec.describe "Incomes", type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user2) }
  let!(:food_expenses) { FactoryBot.create(:food_expenses) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:post) { FactoryBot.create(:post, price:2000, 
    user_id: user.id, 
    category_id: food_expenses.id,
    payment_at: Time.local(2021, 9, 01, 12, 00, 00)) }  
  let!(:income) { FactoryBot.create(:income, user_id: user.id) }  
  let!(:income2) { FactoryBot.create(:income2, user_id: user2.id) }  
  let!(:other_income) { FactoryBot.create(:income, user_id: other_user.id) }  
  # let(:month) { today.beginning_of_month }
  let(:today) { Time.new(2021, 9 ,20, 9, 00, 00) }


  before do
    login user
    travel_to today
  end

  describe "収入の新規作成" do
    before { visit new_income_path }

    it { expect(page).to have_content "収入の記録" }

    it "正しい保存" do
      select '正太郎', from: 'income[user_id]'
      find('#income_payment_at').set("2021-09-25")
      find('#output', visible: false).set('160000')
      fill_in "income_content", with: 'テスト用'
      click_button "記録"
      expect(page).to have_selector('.alert-success', text: '記録を作成しました')
      expect(page).to have_content "収入の記録"
      # post indexのajaxが起動しないので、stat画面で確認
      click_link nil, href: stats_year_path
      expect(page).to have_selector 'span', text: "¥ 420,000"
    end

    it "priceが空欄" do
      select '正太郎', from: 'income[user_id]'
      find('#income_payment_at').set("2021-09-25")
      find('#output', visible: false).set('')
      fill_in "income_content", with: 'テスト用'
      click_button "記録"
      expect(page).to have_content "正しい値を入力してください"
    end

    it "contentが空欄" do
      select '正太郎', from: 'income[user_id]'
      find('#income_payment_at').set("2021-09-25")
      find('#output', visible: false).set('0700')
      fill_in "income_content", with: ''
      click_button "記録"
      expect(page).to have_content "正しい値を入力してください"
    end

    it "日付が空欄" do
      select '正太郎', from: 'income[user_id]'
      find('#income_payment_at').set("")
      find('#output', visible: false).set('0700')
      fill_in "income_content", with: 'テスト用'
      click_button "記録"
      expect(page).to have_content "正しい値を入力してください"
    end


    describe "記録の編集" do
      before { visit edit_income_path(income) }
      
      it "日付を編集" do
        find('#income_payment_at').set('2021-09-20')
        click_on "更新"
        expect(page).to have_selector '.alert-post', text: '編集に成功しました'
        click_link nil, href: stats_year_path
        expect(page).to have_selector 'span', text: "¥ 260,000"
      end
      
      it "値段を編集" do
        find('#output', visible: false).set('60000')
        click_on "更新"
        expect(page).to have_selector '.alert-post', text: '編集に成功しました'
        click_link nil, href: stats_year_path
        expect(page).to have_selector 'span', text: "¥ 160,000"
      end
  
      describe "正しくない編集" do
        it "contentが空欄" do
          fill_in "income_content", with: ''
          click_button "更新"
          expect(page).to have_content "正しい値を入力してください"
        end
    
        it "priceが空欄" do
          find('#output', visible: false).set('')
          click_button "更新"
          expect(page).to have_content "正しい値を入力してください"
        end
      end
  
      it "削除" do
        expect{ click_link "記録の削除" }.to change { Income.count }.by(-1)
      end
    end
  end
end
