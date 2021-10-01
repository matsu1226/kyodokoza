require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { FactoryBot.create(:user, :skip_validate) }
  let!(:user2) { FactoryBot.create(:user2, :skip_validate) }

  
  subject { page }

  before { login(user) }
  
  context "家族登録前" do

    it "家族の登録前は「家族の情報」へのリンクがない" do
      should have_content "家族の登録"
      should_not have_content "家族の情報"
    end

    describe "before_action: check_have_relationship の確認" do
      it "post_new" do
        visit new_post_path
        should have_content "家族の登録をしてください"
        should have_content "設定"
      end
      
      it "post_index" do
        visit posts_path
        should have_content "家族の登録をしてください"
        should have_content "設定"
      end
      
      it "stats_month" do
        visit stats_month_path
        should have_content "家族の登録をしてください"
        should have_content "設定"
      end
      
      it "stats_year" do
        visit stats_year_path
        should have_content "家族の登録をしてください"
        should have_content "設定"
      end
    end

    
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
      
      
      pending "確認ページに遷移する毎に招待コードが更新(view)" do
        click_link "招待コードを作成する"
        before_token = find('#copyTarget').native.inner_html
        click_link "戻る"
        click_link "招待コードを作成する"
        after_token = find('#copyTarget').native.inner_html
        expect(before_token).not_to eq after_token
      end
      
      pending "招待コードがinvitation_digestと一致" do
        # user.invitation_digest = nil
        # user.invitation_token = nil
        click_link "招待コードを作成する"   
        # user.reload
        find '#copyTarget' 
        # reloadでインスタンスにも反映
        token = find('#copyTarget').native.inner_html
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
  end

  
  context "家族を登録" do
    # userのパートナー(になる予定)
    # let(:user2) { FactoryBot.create(:user2, :skip_validate) }

    before do
      visit new_relationship_path
      user2.invitation_token = "0cDOZN79wl3LZw2zTqdnYQ"
      user2.update(invitation_digest: "$2a$12$Oy9pzo/SENDh1AqHvRdYLu9XkrUVpcyTY75HuRoF77Z1SFYtije5G")
    end

    it { expect(user2.invitation_digest).to eq "$2a$12$Oy9pzo/SENDh1AqHvRdYLu9XkrUVpcyTY75HuRoF77Z1SFYtije5G" }
    it { expect(user2.invitation_token).to eq "0cDOZN79wl3LZw2zTqdnYQ" }
    

    describe "既に家族の登録済み" do
      let(:other_user) { FactoryBot.create(:other_user) }
      let!(:relationship) { Relationship.create(name: "他の家族") }
      
      it "自分とほかの誰か" do
        visit user_path(user)
        user.create_user_relationship(relationship_id: relationship.id)
        other_user.create_user_relationship(relationship_id: relationship.id)
        visit new_relationship_path
        expect(page).to have_content "すでに家族が登録されています"
      end

      it "パートナーとほかの誰か" do
        visit user_path(user)
        user2.create_user_relationship(relationship_id: relationship.id)
        other_user.create_user_relationship(relationship_id: relationship.id)
        visit new_relationship_path      
        fill_in "パートナーの招待コード：", with: user2.invitation_token
        fill_in "パートナーの登録メールアドレス：", with: user2.email
        fill_in "登録する家族の名前：", with: "松田家"
        click_button '登録'
        expect(page).to have_content "パートナーが既に他の方と家族登録しています"
      end
    end
    
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

  
  context "家族登録後" do
    let!(:relationship) { FactoryBot.create(:relationship) }

    it { expect(user.relationship.users.count).to eq 3 }
    it { expect(user.relationship.users.count).not_to eq 2 }

    describe "家族の情報" do

      subject { page }
      
      it "家族の情報の表示" do
        visit user_path(user)
        should_not have_content "家族の登録"
        should have_content "松田家"
        should have_content "2021/08/31"
        should have_content "正太郎"
        should have_content "綾美"
      end

      describe "footerの表示" do
        before { visit user_path(user) }
        it { is_expected.to have_link nil, href: posts_path }  
        it { is_expected.to have_link nil, href: stats_month_path }  
        it { is_expected.to have_link nil, href: stats_year_path }  
        it { is_expected.to have_link nil, href: new_post_path } 
        it { is_expected.to have_link nil, href: categories_path } 
      end
    end
  end
end
