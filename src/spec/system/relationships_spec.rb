require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { FactoryBot.create(:user) }   # 登録済みユーザー
  subject { page }
  before { login(user) }
  
  describe "招待コード" do
    before { visit new_relationship_path }
    
    it "確認ページに遷移すると招待コードが更新" do      
      click_link "招待コードを作成する"
      expect { user.reload }.to change { user.invitation_digest }
    end  

    it "確認ページに遷移する毎に招待コードが更新" do      
      click_link "招待コードを作成する"
      user.reload      
      click_link "戻る"
      click_link "招待コードを作成する"
      expect { user.reload }.to change { user.invitation_digest }
    end  
    
    it "招待コードがinvitation_digestと一致" do   ## !!!!
      click_link "招待コードを作成する"   
      user.reload
      # reloadでインスタンスにも反映
      token = find('#copyTarget').native.inner_html
      # digest = user.invitation_digest
      expect(user.authenticated?(:invitation, token)).to eq true
    end

    # it "hoge( find('.hoge').native.inner_html )" do
    #   visit new_relationship_path
    #   click_link "招待コードを作成する"   
    #   hoge = find('.hoge').native.inner_html
    #   expect(hoge).to eq "hoge"
    # end

    # it "招待コードが「確認ページに遷移する前のinvitation_digest」と不一致" do
    #   visit new_relationship_path
    #   invitation_digest = user.invitation_digest
    #   click_link "招待コードを作成する"
    #   invitation_token = find('#copyTarget').native.inner_html
    #   expect do
    #     BCrypt::Password.new(invitation_digest).is_password?(invitation_token)
    #   end.to be_falsey
    # end
    
  end
end
