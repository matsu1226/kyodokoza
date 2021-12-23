# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Categories', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user2) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:food_expenses) { FactoryBot.create(:food_expenses) }
  let!(:food_expenses2) { FactoryBot.create(:food_expenses2) }

  context 'other_user' do
    before do
      login(other_user)
      visit categories_path
    end
    it { expect(page).to have_content '家族の登録をしてください' }
  end

  context 'user' do
    before do
      login(user)
      visit categories_path
    end

    describe 'カテゴリ一覧(自身の家族のカテゴリのみ表示)' do
      it { expect(page).to have_content '食費' }
      it { expect(page).not_to have_content '食費２' }
    end

    describe 'カテゴリの新規作成' do
      before { visit new_category_path }

      it '正しい保存' do
        fill_in 'カテゴリの名前：', with: '食費'
        fill_in 'カテゴリの説明：', with: 'スーパー、買い食い、外食など'
        fill_in '月毎の目標金額：', with: 40_000
        fill_in 'カテゴリカラー：', with: '#ff4500'
        click_button '作成'
        expect(page).to have_content 'カテゴリを作成しました'
        expect(page).to have_content '¥ 76,000'
        expect(page).to have_content '食費'
        expect(page).to have_content 'スーパー、買い食い、外食など'
        expect(page).to have_content '¥ 40,000'
        expect(page).to have_selector '.category-color[style="background-color: #ff4500;"]'
      end

      it '名前が空欄' do
        fill_in 'カテゴリの名前：', with: ''
        fill_in 'カテゴリの説明：', with: 'スーパー、買い食い、外食など'
        fill_in '月毎の目標金額：', with: 36_000
        fill_in 'カテゴリカラー：', with: '#ff4500'
        click_button '作成'
        expect(page).to have_content 'カテゴリの名前を入力してください'
        expect(page).to have_content 'カテゴリの作成'
      end

      it '目標金額が空欄' do
        fill_in 'カテゴリの名前：', with: '食費'
        fill_in 'カテゴリの説明：', with: 'スーパー、買い食い、外食など'
        fill_in '月毎の目標金額：', with: ''
        fill_in 'カテゴリカラー：', with: '#ff4500'
        click_button '作成'
        expect(page).to have_content '目標金額は数値で入力してください'
        expect(page).to have_content 'カテゴリの作成'
      end
    end

    describe 'カテゴリの編集' do
      before { visit edit_category_path(food_expenses) }

      it '他の家族のカテゴリの編集はできない' do
        visit edit_category_path(food_expenses2)
        expect(page).to have_content 'あなた以外の家族の情報は閲覧できません'
      end

      it '正しい編集' do
        fill_in 'カテゴリの名前：', with: '食費'
        fill_in 'カテゴリの説明：', with: 'テスト'
        fill_in 'カテゴリカラー：', with: '#ff4500'
        fill_in '月毎の目標金額：', with: 38_000
        click_button 'カテゴリの更新'
        expect(page).to have_content 'カテゴリを更新しました'
        expect(page).to have_content 'カテゴリ一覧'
        expect(page).to have_content 'テスト'
        expect(page).to have_content '食費'
        expect(page).to have_content '¥ 38,000'
      end

      it '名前が空欄' do
        fill_in 'カテゴリの名前：', with: ''
        click_button 'カテゴリの更新'
        expect(page).to have_content 'カテゴリの名前を入力してください'
        expect(page).to have_content 'カテゴリの編集'
      end

      it '目標金額が空欄' do
        fill_in '月毎の目標金額：', with: ''
        click_button 'カテゴリの更新'
        expect(page).to have_content '目標金額は数値で入力してください'
        expect(page).to have_content 'カテゴリの編集'
      end

      it '削除' do
        click_link 'カテゴリの削除'
        expect(page).to have_content 'カテゴリを削除しました'
        expect(page).to have_content 'カテゴリ一覧'
      end
    end
  end
end
