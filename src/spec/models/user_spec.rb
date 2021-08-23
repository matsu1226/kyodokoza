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

end
