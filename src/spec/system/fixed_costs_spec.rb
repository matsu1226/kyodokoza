require 'rails_helper'

RSpec.describe "FixedCosts", type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user2) }
  let!(:relationship) { FactoryBot.create(:relationship) }
  let!(:common_user) { User.find_by(email: "common_1@kyodokoza.com") }
  let!(:food_expenses) { FactoryBot.create(:food_expenses) }
  let!(:fixed_cost) { FactoryBot.create(:fixed_cost, relationship: relationship) }
  let!(:fixed_cost_template) { FactoryBot.create(:fixed_cost_template, 
                                                  user_id: common_user.id,
                                                  category_id: fixed_cost.id ) }
  let(:today) { Time.new(2021, 9 ,1, 9, 00, 00) }

  before do
    login(user)
    travel_to today
  end

  describe "テンプレートの新規作成" do
    before { visit new_fixed_cost_path }

    it "正しい保存" do
      select '固定費', from: 'fixed_cost[category_id]'
      select '共通', from: 'fixed_cost[user_id]'
      find('#fixed_cost_payment_date').set(27)
      find('#output', visible: false).set('75000')
      fill_in "fixed_cost_content", with: '家賃_テスト用'
      click_button "記録"
      # expect(flash[:post]).to be_present
      expect(page).to have_selector('.alert-fixed_cost', text: 'テンプレートを作成しました')
      expect(page).to have_content "テンプレート一覧"
      expect(page).to have_content "27"
      expect(page).to have_content "固定費"
      expect(page).to have_content "¥ 75,000"
      expect(page).to have_content "家賃_テスト用"
      expect(page).to have_content "共通"
    end

    it "priceが空欄" do
      select '固定費', from: 'fixed_cost[category_id]'
      select '共通', from: 'fixed_cost[user_id]'
      find('#fixed_cost_payment_date').set(27)
      find('#output', visible: false).set('')
      fill_in "fixed_cost_content", with: '家賃_テスト用'
      click_button "記録"
      expect(page).to have_selector('.alert-warning', text: '正しい値を入力してください')
      expect(page).to have_content "テンプレートの作成"
    end

    it "contentが空欄" do
      select '固定費', from: 'fixed_cost[category_id]'
      select '共通', from: 'fixed_cost[user_id]'
      find('#fixed_cost_payment_date').set(27)
      find('#output', visible: false).set('75000')
      fill_in "fixed_cost_content", with: ''
      click_button "記録"
      expect(page).to have_selector('.alert-warning', text: '正しい値を入力してください')
      expect(page).to have_content "テンプレートの作成"
    end

    it "日付が空欄" do
      select '固定費', from: 'fixed_cost[category_id]'
      select '共通', from: 'fixed_cost[user_id]'
      find('#fixed_cost_payment_date').set('')
      find('#output', visible: false).set('75000')
      fill_in "fixed_cost_content", with: '家賃_テスト用'
      click_button "記録"
      expect(page).to have_selector('.alert-warning', text: '正しい値を入力してください')
      expect(page).to have_content "テンプレートの作成"
    end

    it "日付が32" do
      select '固定費', from: 'fixed_cost[category_id]'
      select '共通', from: 'fixed_cost[user_id]'
      find('#fixed_cost_payment_date').set(32)
      find('#output', visible: false).set('75000')
      fill_in "fixed_cost_content", with: '家賃_テスト用'
      click_button "記録"
      expect(page).to have_selector('.alert-warning', text: '正しい値を入力してください')
      expect(page).to have_content "テンプレートの作成"
    end

  end

  context "テンプレート作成後" do
    before do
      visit fixed_costs_path 
    end

    describe "テンプレート一覧" do
      
      it { expect(page).to have_content "テンプレート一覧" }
      it { expect(page).to have_content "75,000" }
      it { expect(page).to have_content "固定費" }
      it { expect(page).to have_content "27" }
      it { expect(page).to have_content "共通" }
    end
    
    describe "テンプレートの編集" do
      before { visit fixed_costs_path }
      
      it "日付を編集" do
        click_link nil, href: edit_fixed_cost_path(fixed_cost_template.id)
        find('#fixed_cost_payment_date').set(25)
        click_button "更新"
        expect(page).to have_selector('.alert-fixed_cost', text: 'テンプレートを更新しました')
        expect(page).to have_content "テンプレート一覧"
        expect(page).to have_content "25"
      end

      it "値段を編集" do
        click_link nil, href: edit_fixed_cost_path(fixed_cost_template.id)
        find('#output', visible: false).set('77000')
        click_button "更新"
        expect(page).to have_selector('.alert-fixed_cost', text: 'テンプレートを更新しました')
        expect(page).to have_content "¥ 77,000"
      end
      
      it "ユーザーを編集" do
        click_link nil, href: edit_fixed_cost_path(fixed_cost_template.id)
        select '正太郎', from: 'fixed_cost[user_id]'
        click_button "更新"
        expect(page).to have_selector('.alert-fixed_cost', text: 'テンプレートを更新しました')
        expect(page).to have_content "正太郎"
      end
      
      describe "正しくない編集" do
        it "contentが空欄" do
          click_link nil, href: edit_fixed_cost_path(fixed_cost_template.id)
          fill_in "fixed_cost_content", with: ''
          click_button "更新"
          expect(page).to have_content "正しい値を入力してください"
        end
        
        it "priceが空欄" do
          click_link nil, href: edit_fixed_cost_path(fixed_cost_template.id)
          find('#output', visible: false).set('')
          click_button "更新"
          expect(page).to have_content "正しい値を入力してください"
        end
      end

      it "削除" do
        click_link nil, href: edit_fixed_cost_path(fixed_cost_template.id)
        expect{ click_link "削除" }.to change { FixedCost.count }.by(-1)
      end
      
    end

    describe "テンプレートの反映" do
      let!(:fixed_cost_template2) { FactoryBot.create(:fixed_cost_template2, 
                                                        user_id: user.id,
                                                        category_id: fixed_cost.id ) }

      before do
        visit fixed_costs_path 
      end

      it "正しい反映" do
        click_button "今月の記録に反映"
        click_link nil, href: posts_path
        expect(page).to have_content "27(月)"
        expect(page).to have_content "固定費"
        expect(page).to have_content "¥ 75,000"
        expect(page).to have_content "家賃"
        expect(page).to have_content "共通"

        expect(page).to have_content "01(水)"
        expect(page).to have_content "固定費"
        expect(page).to have_content "¥ 60,000"
        expect(page).to have_content "健康保険"
        expect(page).to have_content "正太郎"
      end

      it "選択したテンプレートが0件" do
        uncheck "fixed_cost_#{fixed_cost_template.id}"
        uncheck "fixed_cost_#{fixed_cost_template2.id}"
        click_button "今月の記録に反映"
        expect(page).to have_selector('.alert-fixed_cost', text: 'テンプレートが選択されていません')
      end

    end
  end
end