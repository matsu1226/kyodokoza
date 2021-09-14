require 'rails_helper'

RSpec.describe "Categories", type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user2) }
  let!(:food_expenses) { FactoryBot.create(:food_expenses) }
  let!(:food_expenses2) { FactoryBot.create(:food_expenses2) }
  
  before do
    login(user)
    visit categories_path
  end

  describe "カテゴリ一覧(自身の家族のカテゴリのみ表示)" do
    it { expect(page).to have_content "食費" }
    it { expect(page).not_to have_content "食費２" }
  end

  describe "カテゴリの新規作成" do
    before { visit new_category_path }

    it "正しい保存" do
      fill_in "カテゴリの名前：", with: "食費"
      fill_in "カテゴリの説明：", with: "スーパー、買い食い、外食など"
      fill_in "カテゴリカラー：", with: "#ff4500"
      click_button "作成"
      expect(page).to have_content 'カテゴリを作成しました'
      expect(page).to have_content '食費'
      expect(page).to have_content 'スーパー、買い食い、外食など'
      expect(page).to have_selector '.category-color[style="background-color: #ff4500;"]'      
    end

    it "名前が空欄" do
      fill_in "カテゴリの名前：", with: ""
      fill_in "カテゴリの説明：", with: "スーパー、買い食い、外食など"
      fill_in "カテゴリカラー：", with: "#ff4500"
      click_button "作成"
      expect(page).to have_content 'カテゴリの名前を入力してください'
      expect(page).to have_content 'カテゴリの作成'
    end
  end

  describe "カテゴリの編集" do
    before { visit edit_category_path(food_expenses) }
    
    it "他の家族のカテゴリの編集はできない" do
      visit edit_category_path(food_expenses2) 
      expect(page).to have_content 'あなた以外の家族の情報は閲覧できません'
    end

    it "正しい編集" do
      fill_in "カテゴリの名前：", with: "食材費"
      fill_in "カテゴリの説明：", with: "スーパー、買い食い、外食など"
      fill_in "カテゴリカラー：", with: "#ff4500"
      click_button "カテゴリの更新"
      expect(page).to have_content 'カテゴリを更新しました'
      expect(page).to have_content 'カテゴリ一覧'
      expect(page).to have_content '食材費'
    end

    it "名前が空欄" do
      fill_in "カテゴリの名前：", with: ""
      fill_in "カテゴリの説明：", with: "スーパー、買い食い、外食など"
      fill_in "カテゴリカラー：", with: "#ff4500"
      click_button "カテゴリの更新"
      expect(page).to have_content 'カテゴリの名前を入力してください'
      expect(page).to have_content 'カテゴリの編集'
    end

    it "削除"do 
      click_link "カテゴリの削除"
      expect(page).to have_content 'カテゴリを削除しました'
      expect(page).to have_content 'カテゴリ一覧'
    end
  end



end
