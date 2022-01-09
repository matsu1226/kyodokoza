# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { FactoryBot.create(:user) } # 登録済みユーザー
  let!(:non_activated_user) { FactoryBot.create(:other_user, activated: false) }
  let!(:activated_user) { FactoryBot.create(:user3, activated: true) }
  subject { page }

  context 'ログイン前' do
    describe '表示されないコンテンツの確認' do
      describe 'header & footerのロゴ' do
        before { visit root_path }
        it { is_expected.not_to have_link nil, href: user_path(user) }
        it { is_expected.not_to have_link nil, href: posts_path }
        it { is_expected.not_to have_link nil, href: stats_month_path }
        it { is_expected.not_to have_link nil, href: stats_year_path }
        it { is_expected.not_to have_link nil, href: new_post_path }
        it { is_expected.not_to have_link nil, href: categories_path }
      end
    end

    describe '新規登録' do
      before do
        ActionMailer::Base.deliveries = []
        visit signup_path
      end

      describe '登録フォーム' do
        describe 'DBにアドレスが登録されていないユーザー(新規ユーザー)' do
          it 'ニックネーム空欄エラー' do
            fill_in 'ニックネーム：', with: ''
            fill_in 'メールアドレス：', with: 'test@test.com'
            fill_in 'パスワード：', with: 'testtest'
            fill_in 'パスワード（確認）：', with: 'testtest'
            click_button '仮登録（メール送信）', disabled: true
            expect(page).to have_content 'ニックネームを入力してください'
          end

          it 'メールアドレス空欄エラー' do
            fill_in 'ニックネーム：', with: 'テスト　太郎'
            fill_in 'メールアドレス：', with: ''
            fill_in 'パスワード：', with: 'testtest'
            fill_in 'パスワード（確認）：', with: 'testtest'
            click_button '仮登録（メール送信）', disabled: true
            expect(page).to have_content 'メールアドレスを入力してください'
          end

          it 'password空欄エラー' do
            fill_in 'ニックネーム：', with: 'テスト　太郎'
            fill_in 'メールアドレス：', with: 'test@test.com'
            fill_in 'パスワード：', with: ''
            fill_in 'パスワード（確認）：', with: ''
            click_button '仮登録（メール送信）', disabled: true
            expect(page).to have_content 'パスワードを入力してください'
          end

          let(:test_user) { User.find_by(email: 'test@test.com') }
          it '正常な新規登録' do
            fill_in 'ニックネーム：', with: 'テスト　太郎'
            fill_in 'メールアドレス：', with: 'test@test.com'
            fill_in 'パスワード：', with: 'testtest'
            fill_in 'パスワード（確認）：', with: 'testtest'
            click_button '仮登録（メール送信）', disabled: true
            expect(page).to have_content '仮登録メールを送信しました'
            expect(ActionMailer::Base.deliveries.count).to eq 1
            expect(test_user.name).to eq 'テスト　太郎'
            expect(test_user.email).to eq 'test@test.com'
            expect(test_user.password_digest).to be_a_kind_of(String)
            expect(test_user.authenticated?(:password, 'testtest')).to eq true
          end
        end

        describe '以前に一度仮登録メール送信している(non_activated_userの確認)' do
          it { expect(non_activated_user.activated).to be false }

          it 'ニックネーム空欄エラー' do
            fill_in 'ニックネーム：', with: ''
            fill_in 'メールアドレス：', with: non_activated_user.email
            fill_in 'パスワード：', with: 'testtest'
            fill_in 'パスワード（確認）：', with: 'testtest'
            click_button '仮登録（メール送信）', disabled: true
            expect(page).to have_content 'フォームの入力値が不適切です'
          end

          it 'password空欄エラー' do
            fill_in 'ニックネーム：', with: 'テスト　太郎'
            fill_in 'メールアドレス：', with: non_activated_user.email
            fill_in 'パスワード：', with: ''
            fill_in 'パスワード（確認）：', with: ''
            click_button '仮登録（メール送信）', disabled: true
            expect(page).to have_content 'フォームの入力値が不適切です'
          end

          it '正常な新規登録' do
            fill_in 'ニックネーム：', with: 'テスト　太郎'
            fill_in 'メールアドレス：', with: non_activated_user.email
            fill_in 'パスワード：', with: 'testtest'
            fill_in 'パスワード（確認）：', with: 'testtest'
            click_button '仮登録（メール送信）', disabled: true
            expect(page).to have_content '仮登録メールを送信しました'
            expect(User.find_by(email: non_activated_user.email).name).to eq 'テスト　太郎'
            expect(User.find_by(email: non_activated_user.email).password_digest).to be_a_kind_of(String)
            expect(User.find_by(email: non_activated_user.email).authenticated?(:password, 'testtest')).to eq true
          end
        end

        describe '既に登録している(activated_userの確認)' do
          it '正常な情報' do
            fill_in 'ニックネーム：', with: 'テスト　太郎'
            fill_in 'メールアドレス：', with: activated_user.email
            fill_in 'パスワード：', with: 'testtest'
            fill_in 'パスワード（確認）：', with: 'testtest'
            click_button '仮登録（メール送信）', disabled: true
            expect(page).to have_content 'メールアドレスはすでに存在します'
          end
        end
      end

      describe '本登録メール(@user)' do
        before do
          @user = User.create(
            name: 'テスト　太郎',
            email: 'test@test.com',
            password: 'testtest',
            password_confirmation: 'testtest'
          )
          get edit_account_activation_path(@user.activation_token, email: @user.email)
        end

        it { expect(@user.reload.activated).to be true }
        it { expect(session[:user_id]).to eq @user.id }
      end

      describe '本登録メール(@non_activated_user)' do
        before do
          @user = User.create(
            name: 'テスト　太郎',
            email: 'test@test.com',
            password: 'testtest',
            password_confirmation: 'testtest'
          )
          @user.update(name: 'テスト　太郎２')
          get edit_account_activation_path(@user.activation_token, email: @user.email)
        end

        it { expect(@user.reload.activated).to be true }
        it { expect(session[:user_id]).to eq @user.id }
      end
    end

    describe 'パスワード変更' do
      let(:reset_token) { 'ebetLd6XTqMYxCK5WU6R4A' }
      let(:cost) { ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost }
      let(:new_reset_digest) { BCrypt::Password.create(reset_token, cost: cost) }

      before do
        user.update(reset_digest: new_reset_digest)
        user.update(reset_sent_at: Time.zone.now)
        # user.send_password_reset_email
        visit edit_password_reset_path(reset_token, email: user.email)
      end

      it 'パスワードが空欄' do
        fill_in 'パスワード：', with: ''
        fill_in 'パスワード（確認）：', with: ''
        click_button 'パスワード変更'
        expect(page).to have_content 'パスワードを入力してください'
      end

      it 'パスワードとパスワード（確認）が不一致' do
        fill_in 'パスワード：', with: 'hogehoge'
        fill_in 'パスワード（確認）：', with: 'testtest'
        click_button 'パスワード変更'
        expect(page).to have_content 'パスワード（確認）とパスワードの入力が一致しません'
      end

      it 'パスワード変更に成功' do
        fill_in 'パスワード：', with: 'hogehoge'
        fill_in 'パスワード（確認）：', with: 'hogehoge'
        click_button 'パスワード変更'
        expect(page).to have_content 'パスワードが更新されました'
      end
    end
  end

  context 'ログイン' do
    before { visit login_path }

    it 'ログイン失敗' do
      fill_in 'メールアドレス：', with: user.email
      fill_in 'パスワード：', with: ''
      click_button 'ログイン'
      expect(page).to have_content 'パスワードとメールアドレスの組合せが間違っています'
    end

    it 'ログイン成功' do
      fill_in 'メールアドレス：', with: user.email
      fill_in 'パスワード：', with: user.password
      click_button 'ログイン'
      expect(page).to have_content 'ログインに成功しました'
      expect(page).to have_content '設定' # user_path(user)
    end
  end

  context 'ログイン後' do
    before { login(user) }

    describe '表示されないコンテンツの確認' do
      describe 'introduction' do
        before { visit root_path }
        it { is_expected.not_to have_content '登録済みの方はこちら' }
      end

      describe 'login_path' do
        before { visit login_path }
        it { is_expected.to have_content '既にログインしています' }
        it { is_expected.to have_content '設定' }
      end
    end

    describe '表示されるコンテンツの確認' do
      describe 'header & footer' do
        before { visit root_path }
        it { is_expected.to have_link nil, href: user_path(user) } # 設定icon
        it { is_expected.not_to have_link nil, href: posts_path }
        it { is_expected.not_to have_link nil, href: stats_month_path }
        it { is_expected.not_to have_link nil, href: stats_year_path }
        it { is_expected.not_to have_link nil, href: new_post_path }
        it { is_expected.not_to have_link nil, href: categories_path }
      end

      describe '設定' do
        before { visit user_path(user) }
        it { is_expected.to have_link nil, href: logout_path }
        it { is_expected.to have_link nil, href: edit_user_path(user) }
        it { is_expected.to have_link nil, href: new_relationship_path }
      end

      describe 'before_action :correct_user フィルターの確認' do
        let(:user2) { FactoryBot.create(:user2) }

        it '設定(users#show)' do
          visit user_path(user2)
          is_expected.to have_content '他のユーザーの情報は見ることができません'
        end

        it 'アカウント情報の変更(users#edit)' do
          visit edit_user_path(user2)
          is_expected.to have_content '他のユーザーの情報は見ることができません'
        end
      end
    end

    describe 'ログアウトの実行' do
      before do
        visit user_path(user)
        click_link nil, href: logout_path
      end

      it { is_expected.to have_content 'ログアウトしました。' }
    end

    describe 'アカウント情報の編集' do
      describe 'メール配信設定の変更' do
        before do
          visit edit_user_path(user)
        end

        it '初期設定（配信する」にチェックされていること）を確認' do
          expect(page).to have_checked_field '受け取る'
        end

        it '「配信しない」に変更' do
          choose '受け取らない'
          click_button '配信設定の変更'
          except(user.send_weekly_mail).to be_falsey
        end
      end
      
      describe '名前の変更' do
        before do
          visit edit_user_path(user)
        end

        it '変更失敗' do
          fill_in '新しいニックネーム', with: ''
          click_button '名前の変更'
          expect(page).to have_content 'ニックネームを入力してください'
        end

        it '変更成功' do
          fill_in '新しいニックネーム', with: '松田　正太郎'
          click_button '名前の変更'
          expect(page).to have_content '松田　正太郎'
        end
      end

      it 'パスワード変更リンク' do
        click_button 'パスワード変更はこちら'
        expect(page).to have_content 'パスワード変更'
      end

    end
  end

  context 'ゲストログイン' do
    let(:guest) { User.find_by(email: 'guest_1@example.com') }
    before { visit guest_sign_in_path }
  
    it '家族の情報の表示' do
      visit user_path(guest)
      should_not have_content '家族の登録'
      should have_content 'ゲスト用家族'
      should have_content 'ゲスト_1'
      should have_content 'ゲスト_2'
    end
  
    describe 'footerの表示' do
      before { visit user_path(guest) }
      it { is_expected.to have_link nil, href: posts_path }
      it { is_expected.to have_link nil, href: stats_month_path }
      it { is_expected.to have_link nil, href: stats_year_path }
      it { is_expected.to have_link nil, href: new_post_path }
      it { is_expected.to have_link nil, href: categories_path }
    end
  
    describe 'カテゴリの表示' do
      before { visit categories_path }
      it { is_expected.to have_content '固定費' }
      it { is_expected.to have_content '食費' }
      it { is_expected.to have_content '通信費' }
      it { is_expected.to have_content '雑費' }
    end
  
    describe 'ログアウト' do
      before  do
        visit guest_sign_in_path
        visit user_path(guest)
        click_link nil, href: logout_path
      end
  
      it { expect(Category.where(relationship_id: guest.relationship.id).count).to eq 0 }
      it { expect(Post.where(user_id: guest.relationship.user_ids).count).to eq 0  }
      it { expect(page).to have_content 'ログアウトしました。' }
    end
  end
end
