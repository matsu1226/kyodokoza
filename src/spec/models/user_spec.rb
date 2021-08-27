require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(name: "正太郎", 
                    email: "example@gmail.com",
                    password: "example01",
                    password_confirmation: "example01")
  end
  subject { @user }
  
  it {should respond_to(:name)}
  it {should respond_to(:email)}
  it {should respond_to(:password)}
  it {should respond_to(:password_digest)}
  it {should respond_to(:activation_token)}
  it {should respond_to(:activation_digest)}
  it {should respond_to(:reset_digest)}
  it {should respond_to(:active_relationships)}
  it {should respond_to(:to_user)}
  it {should respond_to(:passive_relationships)}
  it {should respond_to(:from_user)}

  describe "正しいuserを保存するテスト" do
    before { @user.save }
    it { should be_valid }
  end

  context "正しくないuserを保存するテスト" do
    describe "名前が空欄" do
      before { @user.name = " " }
      it { should_not be_valid }
    end

    describe "名前が11文字以上" do
      before { @user.name = "a" * 11 }
      it { should_not be_valid }
    end

    describe "メールが空欄" do
      before { @user.email = " " }
      it { should_not be_valid }
    end

    describe "メールが重複" do
      let(:user_with_same_email) { User.new(name: "健太", 
                                            email: "example@gmail.com",
                                            password: "example02",
                                            password_confirmation: "example02")}
      before do
        @user.save
        user_with_same_email.save
      end
      it { expect(user_with_same_email).not_to be_valid }
    end

    it "メールフォーマットがダメ" do
      address = ["examplegmail.com", "@gmail.com", "example@g_mail.com", "example@gmailcom", "example@gmail.56"] 
      address.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
    
    describe "パスワードが空欄" do
      before { @user.password = " " }
      it { should_not be_valid }
    end

    describe "パスワードが7文字以下" do
      before do
        @user.password = "example" 
        @user.password_confirmation = "example" 
      end  
      it { should_not be_valid }
    end

    describe "パスワードが20文字以上" do
      before do
        @user.password = "example01example01example01" 
        @user.password_confirmation = "example01example01example01" 
      end  
      it { should_not be_valid }
    end
  end

  describe "メソッドのテスト" do
    before { @user.save }

    describe "send_activation_emailのテスト" do
      before { @user.send_activation_email }
      it { expect(ActionMailer::Base.deliveries.count).to eq 1 }
    end

    describe "authenticateのテスト" do
      let(:found_user) { User.find_by(email: @user.email) }
      
      describe "正しいパスワード" do
        it { should eq found_user.authenticate(@user.password) }
      end

      describe "間違ったパスワード" do
        let(:user_with_invalid_password) { found_user.authenticate("invalid") }
        it { should_not eq user_with_invalid_password }
        it { expect(user_with_invalid_password).to be false }
      end
    end

      
    describe "authenticated?のテスト" do
      let(:user_activation_token) { @user.activation_token }
      it { expect(@user.authenticated?(:activation, user_activation_token)).to be_truthy }
    end

    describe "activateのテスト" do
      before { @user.activate }
      it { expect(@user.activated).to be_truthy }
    end

    describe "create_reset_digestのテスト" do
      it { expect{ @user.create_reset_digest }.to change{ @user.reset_token }.from(nil).to(String) }
      it { expect{ @user.create_reset_digest }.to change{ @user.reset_digest }.from(nil).to(String) }
    end

    describe "send_password_reset_emailのテスト" do
      before do
        @user.create_reset_digest
        @user.send_password_reset_email 
      end

      it { expect(ActionMailer::Base.deliveries.count).to eq 1 }
    end

    describe "password_reset_expired? のテスト" do    
      describe "2時間以内" do
        before do
          @user.create_reset_digest
          @user.update(reset_sent_at: 1.hour.ago)
        end
        it { expect(@user.password_reset_expired?).to be_falsy }
      end

      describe "2時間以上" do
        before do
          @user.create_reset_digest
          @user.update(reset_sent_at: 1.day.ago)
        end
        it { expect(@user.password_reset_expired?).to be_truthy }
      end
    end

  end

end
