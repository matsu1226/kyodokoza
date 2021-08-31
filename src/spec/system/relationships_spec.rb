require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { FactoryBot.create(:user) }   # 登録済みユーザー
  subject { page }
  before { login(user) }
  
  describe "招待コードの確認" do
    before { visit new_relationship_path }
    
    it "確認ページに遷移するとinvitation_digestが更新" do
      click_link "招待コードを作成する"
      expect { user.reload }.to change { user.invitation_digest }
    end  
    
    it "確認ページに遷移する毎にinvitation_digestが更新" do      
      click_link "招待コードを作成する"
      user.reload      
      click_link "戻る"
      click_link "招待コードを作成する"
      expect { user.reload }.to change { user.invitation_digest }
    end 
    
    let(:token) { find('#copyTarget').native.inner_html }
    
    pending "確認ページに遷移する毎に招待コードが更新" do
      click_link "招待コードを作成する"
      expect do
        click_link "戻る"
        click_link "招待コードを作成する"
      end.to change { token } 
    end
    
    pending "招待コードがinvitation_digestと一致" do
      # user.invitation_digest = nil
      # user.invitation_token = nil
      click_link "招待コードを作成する"   
      user.reload
      find '#copyTarget' 
      # reloadでインスタンスにも反映
      # token = find('#copyTarget').native.inner_html
      # digest = user.invitation_digest
      expect(token).to be_a_kind_of(String) 
      expect(user.invitation_digest).to be_a_kind_of(String) 
      expect(user.authenticated?(:invitation, token)).to eq true    ## <=通らない…。
    end

    # it "hoge( find('.hoge').native.inner_html )" do
    #   visit new_relationship_path
    #   click_link "招待コードを作成する"   
    #   hoge = find('.hoge').native.inner_html
    #   expect(hoge).to eq "hoge"
    # end
    
  end
  
  describe "家族を登録" do
    let(:user2) { FactoryBot.create(:user2) }
    
    before do
      visit new_relationship_path
      user2.invitation_token = "0cDOZN79wl3LZw2zTqdnYQ"
      user2.update(invitation_digest: "$2a$12$Oy9pzo/SENDh1AqHvRdYLu9XkrUVpcyTY75HuRoF77Z1SFYtije5G")
    end

    it { expect(user2.invitation_digest).to eq "$2a$12$Oy9pzo/SENDh1AqHvRdYLu9XkrUVpcyTY75HuRoF77Z1SFYtije5G" }
    it { expect(user2.invitation_token).to eq "0cDOZN79wl3LZw2zTqdnYQ" }


    it "パートナーのメールアドレス不一致" do
      fill_in "パートナーの招待コード：", with: user2.invitation_token
      fill_in "パートナーの登録メールアドレス：", with: ""
      fill_in "登録する家族の名前：", with: "松田家"
      click_button '登録'
      expect(page).to have_content "そのメールアドレスのユーザーは登録されていません"
    end
    
    it "招待コードの不一致" do
      fill_in "パートナーの招待コード：", with: ""
      fill_in "パートナーの登録メールアドレス：", with: user2.email
      fill_in "登録する家族の名前：", with: "松田家"
      click_button '登録'
      expect(page).to have_content "招待コードが間違っています"
    end
    
    pending "自分が既に誰かと家族の登録済み" do
      let(:other_user) { FactoryBot.create(:other_user) }

      before do
        Relationship.new(name: "他の家族", from_user_id: user.id, to_user_id: other_user.id)
      end
      
      it "" do
        fill_in "パートナーの招待コード：", with: user2.invitation_token
        fill_in "パートナーの登録メールアドレス：", with: user2.email
        fill_in "登録する家族の名前：", with: "松田家"
        click_button '登録'
        expect(page).to have_content "家族の登録に失敗しました"
      end
    end

    it "家族名が空欄" do  #
      fill_in "パートナーの招待コード：", with: user2.invitation_token
      fill_in "パートナーの登録メールアドレス：", with: user2.email
      fill_in "登録する家族の名前：", with: ""
      click_button '登録'
      expect(page).to have_content "家族の名前の文字数を確認してください"
    end
    
    it "家族名が7文字以上" do   #
      fill_in "パートナーの招待コード：", with: user2.invitation_token
      fill_in "パートナーの登録メールアドレス：", with: user2.email
      fill_in "登録する家族の名前：", with: "１２３４５６７"
      click_button '登録'
      expect(page).to have_content "家族の名前の文字数を確認してください"
    end
  
    
    it "家族の登録に成功" do    #
      fill_in "パートナーの招待コード：", with: user2.invitation_token
      fill_in "パートナーの登録メールアドレス：", with: user2.email
      fill_in "登録する家族の名前：", with: "松田家"
      click_button '登録'
      expect(page).to have_content "家族を登録しました"
    end

  end

  describe "家族の情報"
end
