# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user2) }
  let!(:other_user) { FactoryBot.create(:other_user) }
  let!(:food_expenses) { FactoryBot.create(:food_expenses) }
  let!(:food_expenses2) { FactoryBot.create(:food_expenses2) }
  let!(:post) do
    FactoryBot.create(:post, price: 2000,
                             user_id: user.id,
                             category_id: food_expenses.id,
                             payment_at: Time.zone.local(2021, 9, 0o1, 12, 0o0, 0o0))
  end
  let!(:post2) do
    FactoryBot.create(:post, price: 2400,
                             user_id: user.id,
                             category_id: food_expenses.id,
                             payment_at: Time.zone.local(2021, 9, 11, 12, 0o0, 0o0))
  end
  let!(:post3) do
    FactoryBot.create(:post, price: 2800,
                             user_id: user.id,
                             category_id: food_expenses.id,
                             payment_at: Time.zone.local(2021, 9, 21, 12, 0o0, 0o0))
  end
  # let(:month) { today.beginning_of_month }
  let(:today) { Time.zone.local(2021, 9, 1, 9, 0o0, 0o0) }

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
      travel_to today
    end

    describe '記録の新規作成' do
      before { visit new_post_path }

      it { expect(page).to have_content '支出の記録' }

      # it "電卓の動作" do
      #   find('button', exact_text: '0').click
      #   find('button', text: '7').click
      #   find('button', exact_text: '0').click
      #   find('button', exact_text: '0').click
      #   expect(page).to have_content "0700"
      # end
      #  JSが絡むテスと =>  https://qiita.com/koki_73/items/ffc115ed542203161cef

      it '正しい保存' do
        select '食費', from: 'post[category_id]'
        select '正太郎', from: 'post[user_id]'
        find('#post_payment_at').set('2021-09-08')
        find('#hidden_field', visible: false).set('0700')
        fill_in 'post_content', with: 'テスト用'
        click_button '記録'
        # expect(flash[:post]).to be_present
        expect(page).to have_selector('.alert-success')
        expect(page).to have_content '支出の記録'
        click_link nil, href: posts_path
        expect(page).to have_content 'テスト用'
        expect(page).to have_content '700'
        expect(page).to have_content '食費'
        expect(page).to have_content '正太郎'
        expect(page).to have_content '08'
      end

      it 'priceが空欄' do
        select '食費', from: 'post[category_id]'
        select '正太郎', from: 'post[user_id]'
        find('#post_payment_at').set('2021-09-08')
        find('#hidden_field', visible: false).set('')
        fill_in 'post_content', with: 'テスト用'
        click_button '記録'
        expect(page).to have_content '正しい値を入力してください'
      end

      it 'contentが空欄' do
        select '食費', from: 'post[category_id]'
        select '正太郎', from: 'post[user_id]'
        find('#post_payment_at').set('2021-09-08')
        find('#hidden_field', visible: false).set('0700')
        fill_in 'post_content', with: ''
        click_button '記録'
        expect(page).to have_content '正しい値を入力してください'
      end

      it '日付が空欄' do
        select '食費', from: 'post[category_id]'
        select '正太郎', from: 'post[user_id]'
        find('#post_payment_at').set('')
        find('#hidden_field', visible: false).set('0700')
        fill_in 'post_content', with: 'テスト用'
        click_button '記録'
        expect(page).to have_content '正しい値を入力してください'
      end
    end

    # describe "記録の一覧(AJAX)", js:true do
    describe '記録の一覧(AJAX)' do
      before { visit posts_path }

      it { expect(page).to have_content '7,200' }
      it { expect(page).to have_content '2021年 9月' }

      pending '月の遷移が正常に作動' do
        find('.prev_month').click
        expect(page).to have_content '2021年 8月'
        find('.prev_month').click
        expect(page).to have_content '2021年 7月'
        find('.next_month').click
        find('.next_month').click
        find('.next_month').click
        expect(page).to have_content '2021年 10月'
      end

      it '絞り込みが正常に作動' do
      end
    end

    describe '記録の編集' do
      before { visit posts_path }

      it '日付を編集' do
        click_link nil, href: edit_post_path(post)
        find('#post_payment_at').set('2021-09-25')
        click_on '更新'
        expect(page).to have_selector 'span', text: '25(土)'
        expect(page).to have_selector '.alert-success'
      end

      it '値段を編集' do
        click_link nil, href: edit_post_path(post)
        find('#hidden_field', visible: false).set('1000')
        click_on '更新'
        expect(page).to have_selector 'td', text: '6,200'
        expect(page).to have_selector '.alert-success'
      end

      describe '正しくない編集' do
        it 'contentが空欄' do
          click_link nil, href: edit_post_path(post)
          fill_in 'post_content', with: ''
          click_button '更新'
          expect(page).to have_content '正しい値を入力してください'
        end

        it 'priceが空欄' do
          click_link nil, href: edit_post_path(post)
          find('#hidden_field', visible: false).set('')
          click_button '更新'
          expect(page).to have_content '正しい値を入力してください'
        end
      end

      it '削除' do
        click_link nil, href: edit_post_path(post)
        expect { click_link '記録の削除' }.to change { Post.count }.by(-1)
      end
    end
  end
end
