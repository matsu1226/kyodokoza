require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { FactoryBot.create(:user) }   # 登録済みユーザー
  subject { page }

  context "ログイン前" do
    describe "表示されないコンテンツの確認" do      
      describe "header & footer" do
        before { visit root_path }
        it { is_expected.not_to have_link nil, href: user_path(user) }   # 設定icon
        # it { is_expected.not_to have_link nil, href: 一覧へのリンク }   # 一覧icon
        # it { is_expected.not_to have_link nil, href: 合計へのリンク }   # 合計icon
        # it { is_expected.not_to have_link nil, href: 記録へのリンク }   # 記録icon
        # it { is_expected.not_to have_link nil, href: 使い方へのリンク } # 使い方icon
      end
    end

    describe "新規登録" do
      before { visit signup_path }

      describe "登録フォーム" do
        it "メールアドレス空欄エラー" do
          fill_in 'ニックネーム：', with: "テスト　太郎"
          fill_in 'メールアドレス：', with: ""
          fill_in 'パスワード：', with: "testtest"
          fill_in 'パスワード（確認）：', with: "testtest"
          click_button '仮登録（メール送信）'
          expect(page).to have_content 'メールアドレスを入力してください'
        end      
        
        it "メールアドレス重複エラー" do
          fill_in 'ニックネーム：', with: "テスト　太郎"
          fill_in 'メールアドレス：', with: user.email
          fill_in 'パスワード：', with: "testtest"
          fill_in 'パスワード（確認）：', with: "testtest"
          click_button '仮登録（メール送信）'
          expect(page).to have_content 'メールアドレスはすでに存在します'
        end
        
        it "正常な新規登録" do
          fill_user_info_and_click_button
          expect(page).to have_content '仮登録メールを送信しました'
        end
        
      end
    
      describe "アカウント有効化" do
        before do
          fill_user_info_and_click_button
          activation_mail = ActionMailer::Base.deliveries.last   # 配信したメールのインスタンスを取得
          mail_body = activation_mail.body.encoded   # 本文をエンコードして取得
          activation_url = URI.extract(mail_body, ["account_activations"])[0]  # 文字列からURLの配列で取得
          # http://localhost:3000/account_activations/6NrI6rdZcVgK4bzWBIchGQ/edit?email=shotaro%40kyodokoza.com
          get activation_url
        end

        it "" do
          visit login_path
          fill_in 'メールアドレス：', with: "test@test.com"
          fill_in 'パスワード：', with: "testtest"
          click_button 'ログイン'
          expect(page).to have_content 'ログインに成功しました'
        end

        # it { expect(page).to have_content('会員登録完了です！') }
      end
    end
  end


  context "ログイン" do
    before { visit login_path }

    it "ログイン失敗" do
      fill_in 'メールアドレス：', with: user.email
      fill_in 'パスワード：', with: ""
      click_button 'ログイン'
      expect(page).to have_content 'パスワードとメールアドレスの組合せが間違っています'
    end

    it "ログイン成功" do
      fill_in 'メールアドレス：', with: user.email
      fill_in 'パスワード：', with: user.password
      click_button 'ログイン'
      expect(page).to have_content 'ログインに成功しました'
    end

  end


  context "ログイン後" do
    before { login(user) }

    describe "表示されないコンテンツの確認" do      
      describe "introduction" do
        before { visit root_path }
        it { is_expected.not_to have_content '登録済みの方はこちら' } 
      end
    end


    describe "表示されるコンテンツの確認" do      
      describe "header & footer" do
        before { visit root_path }
        it { is_expected.to have_link nil, href: user_path(user) }   # 設定icon
        # it { is_expected.to have_link nil, href: 一覧へのリンク }   # 一覧icon
        # it { is_expected.to have_link nil, href: 合計へのリンク }   # 合計icon
        # it { is_expected.to have_link nil, href: 記録へのリンク }   # 記録icon
        # it { is_expected.to have_link nil, href: 使い方へのリンク } # 使い方icon
      end

      describe "設定" do
        before { visit user_path(user) }
        it { is_expected.to have_selector 'a.setting-link-wrapper' }
      end

      describe "アカウント情報変更" do
        before { visit edit_user_path(user) }
        it { is_expected.to have_content 'ニックネームの変更' }
      end      
    end

    describe "ログアウトの実行" do
      before do
        visit user_path(user) 
        find('.logout-wrapeer').click     # 1つ目のsetting-link-wrapperクラスの要素をクリック
      end

      it { is_expected.to have_content 'ログアウトしました。' }
    end

    describe "アカウント情報の編集" do
      describe "名前の変更" do
        before do
          visit edit_user_path(user)
        end

        it "変更失敗" do
          fill_in '新しいニックネーム' , with: ""
          click_button '変更する'
          expect(page).to have_content 'ニックネームを入力してください'
        end

        it "変更成功" do
          fill_in '新しいニックネーム' , with: "松田　正太郎"
          click_button '変更する'
          expect(page).to have_content '松田　正太郎'
        end
      end
      
      pending "パスワード変更リンク" do
        click_button 'パスワード変更はこちら'
        expect(page).to have_content 'パスワード変更'
      end
      
      it "アカウントの削除" do
        visit edit_user_path(user)
        click_on 'アカウント削除'
        # expect(page).to have_content '本当によろしいですか？'
        # click_button 'OK'
        # page.accept_confirm do
        #   click_button 'アカウント削除'
        # end
        expect(page).to have_content 'アカウントを削除しました'
      end
    end

    # ===========

    # describe "家族の登録" do

    #   describe "家族の一覧" do

    #   end
    # end

    # describe "エクセル出力" do

    # end

  end
end
