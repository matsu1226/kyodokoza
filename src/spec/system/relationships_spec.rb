require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { FactoryBot.create(:user) }   # 登録済みユーザー
  subject { page }
  before { login(user) }
  
  describe "招待コード" do
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
end
