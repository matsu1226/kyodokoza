require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(name: "正太郎", 
                    email: "example@gmail.com",
                    password: "example",
                    password_confirmation: "example")
  end
  subject { @user }
  
  it {should respond_to(:name)}
  it {should respond_to(:email)}
  it {should respond_to(:password)}
  it {should respond_to(:password_digest)}

  describe "正しいuserを保存" do
    before { @user.save }
    it { should be_valid }
  end

end
