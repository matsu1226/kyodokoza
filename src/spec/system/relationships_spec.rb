require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { FactoryBot.create(:user) }   # 登録済みユーザー
  subject { page }
  before { login(user) }

  describe "招待コード" do
    
    it "確認ページに遷移するたびに招待コードが更新" do      
      visit new_relationship_path
      expect do
        click_link "招待コードを作成する"
        # user.create_invitation_digest
      end.to change { user.invitation_digest }
    end  
    
    it "招待コードがinvitation_digestと一致" do
      # BCrypt::Password.new("$2a$12$Oy9pzo/SENDh1AqHvRdYLu9XkrUVpcyTY75HuRoF77Z1SFYtije5G").is_password?("0cDOZN79wl3LZw2zTqdnYQ")
    end
    
  end
end
