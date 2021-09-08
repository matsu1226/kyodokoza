require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user2) }
  let!(:food_expenses) { FactoryBot.create(:food_expenses) }
  let!(:food_expenses2) { FactoryBot.create(:food_expenses2) }
  let!(:post) { FactoryBot.create(:post, price:2000, 
                                        user_id: user.id, 
                                        category_id: food_expenses.id,
                                        purchased_at: Time.local(2021, 9, 01, 12, 00, 00)) }  
  let!(:post2) { FactoryBot.create(:post, price:2400, 
                                        user_id: user.id, 
                                        category_id: food_expenses.id,
                                        purchased_at: Time.local(2021, 9, 11, 12, 00, 00)) }  
  let!(:post3) { FactoryBot.create(:post, price:2800, 
                                        user_id: user.id, 
                                        category_id: food_expenses.id,
                                        purchased_at: Time.local(2021, 9, 21, 12, 00, 00)) }   
  
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
      find('#post_purchased_at').set("2021-09-08")
      find('#output', visible: false).set('0700')
      fill_in "post_content", with: 'テスト用'
      click_button "記録"
      # expect(flash[:post]).to be_present
      expect(page).to have_selector('.alert-post', text: '記録を作成しました')
      expect(page).to have_content "テスト用"
      expect(page).to have_content "700"
      expect(page).to have_content "食費"
      expect(page).to have_content "正太郎"
      expect(page).to have_content "08"
    end

    it "priceが空欄" do
      select '食費', from: 'post[category_id]'
      select '正太郎', from: 'post[user_id]'
      find('#post_purchased_at').set("2021-09-08")
      find('#output', visible: false).set('')
      fill_in "post_content", with: 'テスト用'
      click_button "記録"
      expect(page).to have_selector 'div.field_with_errors'
    end

    it "contentが空欄" do
      select '食費', from: 'post[category_id]'
      select '正太郎', from: 'post[user_id]'
      find('#post_purchased_at').set("2021-09-08")
      find('#output', visible: false).set('0700')
      fill_in "post_content", with: ''
      click_button "記録"
      expect(page).to have_selector 'div.field_with_errors'
    end

    it "日付が空欄" do
      select '食費', from: 'post[category_id]'
      select '正太郎', from: 'post[user_id]'
      find('#post_purchased_at').set("")
      find('#output', visible: false).set('0700')
      fill_in "post_content", with: 'テスト用'
      click_button "記録"
      expect(page).to have_selector 'div.field_with_errors'
    end
  end

  describe "記録の一覧" do
    before { visit posts_path }
    
    it { expect(page).to have_content "7,200" }
  end
  
  describe "記録の編集" do
    before { visit posts_path }
    
    it "日付を編集" do
      click_link nil, href: edit_post_path(post)
      find('#post_purchased_at').set('2021-09-25')
      click_on "更新"
      expect(page).to have_selector 'span', text: "25(土)"
      expect(page).to have_selector '.alert-post', text: '編集に成功しました'
    end
    
    it "値段を編集" do
      click_link nil, href: edit_post_path(post)
      find('#output', visible: false).set('1000')
      click_on "更新"
      expect(page).to have_selector 'p', text: "6,200"
      expect(page).to have_selector '.alert-post', text: '編集に成功しました'
    end

    describe "正しくない編集" do
      it "contentが空欄" do
        click_link nil, href: edit_post_path(post)
        fill_in "post_content", with: ''
        click_button "更新"
        expect(page).to have_selector 'div.field_with_errors'
      end
  
      it "priceが空欄" do
        click_link nil, href: edit_post_path(post)
        find('#output', visible: false).set('')
        click_button "更新"
        expect(page).to have_selector 'div.field_with_errors'
      end
    end

    it "削除" do
      click_link nil, href: edit_post_path(post)
      expect{ click_link "記録の削除" }.to change { Post.count }.by(-1)
    end
    
  end

end
