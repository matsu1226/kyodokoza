require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user2) }
  let!(:food_expenses) { FactoryBot.create(:food_expenses) }
  let!(:food_expenses2) { FactoryBot.create(:food_expenses2) }
  
  before do
    login(user)
  end

  describe "記録の新規作成" do
    before { visit new_post_path }

    it { expect(page).to have_content "支出の記録" }

    # it "電卓の動作" do
    #   find('button', exact_text: '0').click
    #   find('button', text: '7').click
    #   find('button', exact_text: '0').click
    #   find('button', exact_text: '0').click
    #   expect(page).to have_content "0700"
    # end
  #  JSが絡むテスと =>  https://qiita.com/koki_73/items/ffc115ed542203161cef

    it "正しい保存" do
      select '食費', from: 'post[category_id]'
      select '正太郎', from: 'post[user_id]'
      # find("#post_category_id").find("option[value='1']").select_option
      # find("#post_user_id").find("option[value='1']").select_option
      fill_in "post_content", with: 'テスト用'
      find('#output', visible: false).set('0700')
      click_button "記録"
      expect(page).to have_content "記録をを作成しました"
      expect(page).to have_content "テスト用"
      expect(page).to have_content "700"
      expect(page).to have_content "食費"
      expect(page).to have_content "正太郎"
    end

    it "priceが空欄" do
      select '食費', from: 'post[category_id]'
      select '正太郎', from: 'post[user_id]'
      # find("#post_category_id").find("option[value='1']").select_option
      # find("#post_user_id").find("option[value='1']").select_option
      fill_in "post_content", with: 'テスト用'
      find('#output', visible: false).set('')
      click_button "記録"
      expect(page).to have_content "支出の記録"
    end

    it "contentが空欄" do
      select '食費', from: 'post[category_id]'
      select '正太郎', from: 'post[user_id]'
      # find("#post_category_id").find("option[value='1']").select_option
      # find("#post_user_id").find("option[value='1']").select_option
      fill_in "post_content", with: ''
      find('#output', visible: false).set('0700')
      click_button "記録"
      expect(page).to have_content "支出の記録"
    end
  end

  describe "記録の一覧" do
    let!(:post) { FactoryBot.create_list(:post, user_id: user.id, category_id: food_expenses.id, 3) }
    before { visit posts_path }
    
    it { expect(page).to have_content "7,200" }
  end

end
