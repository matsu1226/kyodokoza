require 'rails_helper'

RSpec.describe "Categories", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user2) }
  let!(:relationship) { Relationship.create(id: 1, name: "松田家") }
  let!(:food_expenses) { FactoryBot.create(:food_expenses) }
  

  before do
    user.create_user_relationship(relationship_id: 1)          
    user2.create_user_relationship(relationship_id: 1) 
    login(user)
    visit categories_path
  end

  describe "カテゴリの新規作成" do
    before { visit new_category_path }

    it "正しい保存" do
      fill_in "カテゴリの名前：", with: "食費"
      fill_in "カテゴリの説明：", with: "スーパー、買い食い、外食など"
      fill_in "カテゴリカラー：", with: "#f00"
      click_button "作成"
      expect(page).to have_content 'カテゴリを作成しました'
    end

    it "名前が空欄" do
      fill_in "カテゴリの名前：", with: ""
      fill_in "カテゴリの説明：", with: "スーパー、買い食い、外食など"
      fill_in "カテゴリカラー：", with: "#f00"
      click_button "作成"
      expect(page).to have_content 'カテゴリの名前を入力してください'
    end
  end

  it "カテゴリ一覧でただしいコンテンツの表示" do
    expect(page).to have_content '食費'
    expect(page).to have_content 'スーパー、買い食い、外食など'
    expect(page).to have_selector '.category-color[style="background-color: #f00;"]'
  end

  # カテゴリの名前を入力してください

end
