require 'rails_helper'

RSpec.describe Income, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user2) }

  before do
    @income = Income.new(user_id: user.id, 
                    content: "給料", 
                    payment_at: Time.local(2021, 9, 1, 12, 00, 00),
                    price: 160000)
  end

  subject { @income }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:price) }
  it { should respond_to(:payment_at) }
  it { should respond_to(:user) }


  it "contentが空欄" do
    @income.content = ""
    should_not be_valid
  end

  it "contentが31文字以上" do
    @income.content = "a" * 31
    should_not be_valid
  end
  
  it "priceが空欄" do
    @income.price = ""
    should_not be_valid
  end
  
  it "priceがマイナス" do
    @income.price = -1
    should_not be_valid
  end

  it "user_idが空欄" do
    @income.user_id = ""
    should_not be_valid
  end

  it "payment_atが空欄" do
    @income.payment_at = ""
    should_not be_valid
  end
end
