require 'rails_helper'

RSpec.describe "Posts", type: :system do
  # let!(:user) { FactoryBot.create(:user) }
  # let!(:user2) { FactoryBot.create(:user2) }
  # let!(:food_expenses) { FactoryBot.create(:food_expenses) }
  # let!(:food_expenses2) { FactoryBot.create(:food_expenses2) }
  
  # before do
  #   login(user)
  # end

  # describe "記録の新規作成" do
  #   before { new_post_path }

  #   it "電卓の動作" do
  #     find('button', text: '7').click
  #     find('button', text: '0').click
  #     find('button', text: '0').click
  #     expect(page).to have_content "0700"
  #   end

  #   it "正しい保存" do
  #     select "食費", from: 'post_category_id'
  #     select "正太郎", from: 'post_user_id'
  #     fill_in "post_content", with: 'テスト用'
  #     fill_in "700", with: 'output'
  #     click_button "記録"
  #     expect(page).to have_content "記録をを作成しました"
  #     expect(page).to have_content "テスト用"
  #     expect(page).to have_content "700"
  #   end
  # end
end
