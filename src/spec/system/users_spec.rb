require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { FactoryBot.create(:user) }   # 登録済みユーザー
  subject { page }

  context "ログイン前" do
    describe "表示されないコンテンツの確認" do      
      describe "header & footerのロゴ" do
        before { visit root_path }
        it { is_expected.not_to have_link nil, href: user_path(user) }   # 設定icon
        # it { is_expected.not_to have_link nil, href: 一覧へのリンク }   # 一覧icon
        # it { is_expected.not_to have_link nil, href: 合計へのリンク }   # 合計icon
        # it { is_expected.not_to have_link nil, href: 記録へのリンク }   # 記録icon
        # it { is_expected.not_to have_link nil, href: 使い方へのリンク } # 使い方icon
      end
    end

    describe "新規登録" do
      before do
        ActionMailer::Base.deliveries = [] 
        visit signup_path 
      end

      let(:test_user) { User.find_by(email: "test@test.com") }

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
          fill_test_user_info_and_click_button
          expect(page).to have_content '仮登録メールを送信しました' 
          expect(ActionMailer::Base.deliveries.count).to eq 1  
          expect( test_user.name ).to eq "テスト　太郎" 
          expect( test_user.email ).to eq "test@test.com" 
          expect( test_user.password_digest ).to be_a_kind_of(String) 
          expect( test_user.authenticated?(:password, "testtest") ).to eq true 
        end
      end
    
      # describe "アカウント有効化" do
      #   # let(:test_user) { User.new(name:"test" ,email: "test@test.com", password: "testtest", password_confirmation: "testtest") }
      #   let(:activation_mail) { ActionMailer::Base.deliveries.last }  # 配信したメールのインスタンスを取得
      #   let(:mail_body) { activation_mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join }              # 本文をエンコードして取得
      #   let(:activation_url) { URI.extract(mail_body, ["account_activations"])[0] }   # 文字列からURLの配列で取得

      #   # it { expect{ test_user.save }.to change{ test_user.activation_token }.from(nil).to(String) }
        
      #   before do
      #     ActionMailer::Base.deliveries = [] 
      #     fill_test_user_info_and_click_button    # user.save, sending activation_mail
      #   end
        # it { expect( test_user.activation_token ).to be_a_kind_of(String) }
        # it { expect( mail_body ).to include test_user.activation_token }
        # it { expect( activation_url ).to include test_user.activation_token }
        
        # it { expect(test_user.authenticated?(:activation, test_user.activation_token)).to eq true }
        
        # it "アカウント有効化" do
        #   get activation_url  # account_activetions#edit
        #   visit login_path
        #   fill_in 'メールアドレス：', with: "test@test.com"
        #   fill_in 'パスワード：', with: "testtest"
        #   click_button 'ログイン'
        #   expect(page).to have_content 'ログインに成功しました'
        # end

        # it { expect(page).to have_content('会員登録完了です！') }
      # end
    end

    describe "パスワード変更" do
      let(:reset_token) { "ebetLd6XTqMYxCK5WU6R4A" }
      let(:cost){ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost }
      let(:new_reset_digest) { BCrypt::Password.create(reset_token, cost: cost) }

      before do
        user.update(reset_digest: new_reset_digest)
        user.update(reset_sent_at: Time.zone.now)
        # user.send_password_reset_email
        visit edit_password_reset_path(reset_token, email: user.email)
      end
      
      it "パスワードが空欄" do
        fill_in 'パスワード：', with: ""
        fill_in 'パスワード（確認）：', with: ""
        click_button 'パスワード変更'
        expect(page).to have_content 'パスワードを入力してください'
      end

      it "パスワードとパスワード（確認）が不一致" do
        fill_in 'パスワード：', with: "hogehoge"
        fill_in 'パスワード（確認）：', with: "testtest"
        click_button 'パスワード変更'
        expect(page).to have_content 'パスワード（確認）とパスワードの入力が一致しません'
      end

      it "パスワード変更に成功" do
        fill_in 'パスワード：', with: "hogehoge"
        fill_in 'パスワード（確認）：', with: "hogehoge"
        click_button 'パスワード変更'
        expect(page).to have_content 'パスワードが更新されました'
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

      describe "before_action :correct_user フィルターの確認" do
        it "設定(users#show)" do
          visit user_path(100)
          is_expected.to have_content '他のユーザーの情報を見ることはできません' 
        end

        it "アカウント情報の変更(users#edit)" do
          visit edit_user_path(100)
          is_expected.to have_content '他のユーザーの情報を見ることはできません' 
        end

        it "アカウント情報の更新(users#update)" do
          PATCH user_path(100)
          is_expected.to have_content '他のユーザーの情報を見ることはできません' 
        end

        it "アカウントの削除(users#destroy)" do
          DELETE user_path(100)
          is_expected.to have_content '他のユーザーの情報を見ることはできません' 
        end

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
